//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-04
// 描述:	   尸检病理申请单
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var editSelRow = -1;    /// 当前编辑行
var PisID = "";         /// 病理申请ID
var isWriteFlag = "-1";
var rowNo = 4; 			 /// 标本序号
var pid = "";  			 /// 唯一标识
var mListDataDoc = "";   /// 医生站界面参数内容
var DocMainFlag = "";    /// 医生站界面弹出标示
var LgUserID = session['LOGON.USERID'];   /// 用户ID
var LgCtLocID = session['LOGON.CTLOCID']; /// 科室ID
var LgGroupID = session['LOGON.GROUPID']; /// 安全组ID
var LgHospID=session['LOGON.HOSPID'];
var isPageEditFlag = 1; /// 页面是否允许编辑

/// 页面初始化函数
function initPageDefault(){

	InitPageDataGrid();		  /// 初始化页面datagrid
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	//LoadCheckItemList();      /// 加载病理检查项目
	GetPatBaseInfo();         /// 加载病人信息
	GetIsWriteFlag();         /// 是否可填写判断
	InitPageCheckBox();		  /// 页面CheckBox控制  sufan 2018-01-30 
	InitVersionMain();        /// 页面兼容配置
}

/// 页面兼容配置
function InitVersionMain(){
	
	/// 弹出界面时,检查申请采用新版录入界面
	if (DocMainFlag == 1){
		$('#tPanel').panel({closed:true});        /// 隐藏【申请信息】
		$('#mainPanel').layout("remove","south"); /// 隐藏【按钮栏】
		$('a:contains("取消申请")').hide();
		$('a:contains("发送")').hide();
		$('a:contains("打印")').hide();
		LoadCheckItemListDoc();      /// 加载病理检查项目
		var PanelWidth = window.parent.frames.GetPanelWidth();
		/// 面板【申请信息】大小调整 
		$('#mPanel').panel('resize',{width: PanelWidth ,height: 100});
		/// 面板【标本信息】大小调整
		$('#sPanel').panel('resize',{width: PanelWidth ,height: 209});
		/// 面板【病人病历】大小调整
		$('#cPanel').panel('resize',{width: PanelWidth ,height: 450});
	}else{
		LoadCheckItemList();         /// 加载病理检查项目
	}
}

/// 重新设置datagrid大小
function resize(){

	$('#PisSpecList').datagrid('resize',{width: 800,height: 200 });
	//$('#PisSpecList').datagrid('resize',{ });
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	EpisodeID = getParam("EpisodeID");
	PisID = getParam("itemReqID");  /// 申请单ID
	
	/// 以下为医生站弹出参数 内容
	pid = getParam("pid");         /// 唯一标识
	mListDataDoc = getParam("ARCIMStr");
	if (mListDataDoc != ""){
		DocMainFlag = 1;
		var mParam = mListDataDoc.split("!")[0];
		if (mParam != ""){
			EpisodeID = mParam.split("^")[0];
		}
	}
}

/// 初始化界面控件内容
function InitPageComponent(){
	
	/// 接收科室
	var option = {
		panelHeight:"auto",
		onSelect:function(option){
		},
		onShowPanel:function(){
			var itmmastid = $("#TesItemID").val();
			if (itmmastid != ""){
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID="+itmmastid;
				$("#recLoc").combobox('reload',unitUrl);
			}
		}
	}
	new ListCombobox("recLoc",'','',option).init();
	
	/// 病理检查项目选中事件
	$("#itemList").on("click",".checkbox",TesItm_onClick);
	
	/// 申请科室 
	$('#ApplyLoc').combobox({	//申请科室和申请医生可以选择(默认就诊医生和科室) 2018/2/5 qunianpeng 
		mode:'remote',  
		onShowPanel:function(){
			var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&hospId="+LgHospID;
			$("#ApplyLoc").combobox('reload',unitUrl);
		},
		onSelect:function(){	//设置级联 选择科室后，加载可以登录该科室的医生 qunianpeng 2018/2/7
			$("#ApplyDocUser").combobox("setValue","");
			$("#ApplyDocUser").combobox('reload');
		}
	});
	
	/// 申请医生  
	$('#ApplyDocUser').combobox({
		//mode:'remote',  
		onShowPanel:function(){
			var appLocID=$('#ApplyLoc').combobox('getValue');
			var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+appLocID;
			$("#ApplyDocUser").combobox('reload',unitUrl);
		}
	});	
	
	/// 界面按钮状态
	$('a:contains("取消申请")').linkbutton('disable');
	$('a:contains("取消申请")').removeClass('btn-lightred');
	$('a:contains("发送")').linkbutton('disable');
	$('a:contains("发送")').removeClass('btn-lightgreen');
	$('a:contains("打印")').linkbutton('disable');
}

/// 选中检查项目
function TesItm_onClick(){
	
	if ($(this).is(':checked')){
		
		if (isWriteFlag != "Y"){
			$.messager.alert("提示:","仅有死亡患者才能填写尸检申请单！");
			$(this).attr("checked",false);
			return;
		}
		
		/// 诊断判断
		if (window.parent.frames.GetMRDiagnoseCount() == 0){
			$.messager.alert("提示:","病人没有诊断,请先录入！","",function(){window.parent.frames.DiagPopWin()});
			$(this).attr("checked",false);
			return;	
		}
		
		/// 检查方法【医嘱项ID、医嘱项名称】
		var TesItemID = this.id;    /// 检查方法ID
		var TesItemDesc = $(this).parent().next().text(); /// 检查方法
		var itmmastid = TesItemID.replace("_","||");
		$("#TesItemID").val(itmmastid);
		$("#TesItemDesc").val(TesItemDesc);

		/// 医嘱的性别/年龄限制
		var LimitMsg = window.parent.frames.GetItmLimitMsg(itmmastid)
		if (LimitMsg != ""){
			$.messager.alert("提示:","项目【" +TesItemDesc+ "】被限制使用：" + LimitMsg);
			return;	
		}

		/// 接收科室
		var LocID = ""; var LocDesc = "";
		runClassMethod("web.DHCAPPExaReportQuery","jsonItmDefaultRecLoc",{"EpisodeID":EpisodeID, "ItmmastID":itmmastid},function(jsonString){
			
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				LocID = jsonObjArr[0].value;
				LocDesc = jsonObjArr[0].text;
			}
		},'json',false)

		$("#recLoc").combobox("setValue",LocID);
		$("#recLoc").combobox("setText",LocDesc);
	}
}

/// 加载检查方法列表
function LoadCheckItemList(){
	
	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCAPPExaReportQuery","JsonGetTraItmByCode",{"Code":"APY"},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegion(itemobj){	
	/// 标题行
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;">'+ itemobj.text +'</td></tr>';

	/// 项目
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="ExaItem" type="checkbox" class="checkbox" value="'+ itemobj.id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(htmlstr+itemhtmlstr)
}

/// 页面DataGrid初始定义已选列表
function InitPageDataGrid(){
	
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
		
	/// 数字编辑格
	var numberboxeditor = {
		type: 'numberbox',//设置编辑格式
		options: {
			//required: true //设置编辑规则属性
		}
	}
	
	var TitLnk = '<a href="#" onclick="insRow()"><img style="margin:6px 3px 0px 3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>';
	///  定义columns
	var columns=[[
		{field:'No',title:'标本序号',width:100,align:'center'},
		//{field:'ID',title:'标本标识',width:120,editor:texteditor},
		{field:'Name',title:'标本名称',width:300,editor:texteditor,align:'center'},
		{field:'Part',title:'标本部位',width:120,editor:texteditor,hidden:true},
		{field:'Qty',title:'标本数量',width:100,editor:numberboxeditor,align:'center'},
		{field:'Remark',title:'备注',width:280,editor:texteditor},
		{field:'operation',title:TitLnk,width:40,align:'center',
			formatter:SetCellUrl}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		fitColumn:true,
		headerCls:'panel-header-gray',
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		onClickRow:function(rowIndex, rowData){

	    },
		onLoadSuccess:function(data){
			
		},
		rowStyler:function(index,rowData){   

	    },
	    onDblClickRow: function (rowIndex, rowData) {
			
			if (isPageEditFlag == 0) return;
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#PisSpecList").datagrid('endEdit', editSelRow); 
            } 
            $("#PisSpecList").datagrid('beginEdit', rowIndex); 

            editSelRow = rowIndex; 
        }
	};
	/// 就诊类型
	var uniturl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=JsonQryPisSpec&PisID="+PisID;
	new ListComponent('PisSpecList', columns, uniturl, option).Init();
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){	
	return "<a href='#' onclick='delRow("+ rowIndex +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

/// 删除行
function delRow(rowIndex){
	
	if (isPageEditFlag == 0) return;
	var rows = $('#PisSpecList').datagrid('getRows');
  	//删除前结束所有的编辑行
	$.each(rows,function(index,data){
		 if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#PisSpecList").datagrid('endEdit', editSelRow); 
            }
	});
    /// 行对象
    var rowObj = {"No":rowNo+1,"Name":"","Part":"","Qty":"","Remark":""};		
	/// 当前行数大于4,则删除，否则清空
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	
	if(rows.length>4){
		 $('#PisSpecList').datagrid('deleteRow',rowIndex);
		  rowNo -= 1;
	}else{
		//$('#PisSpecList').datagrid('updateRow',{index:rowIndex, row:rowObj});
		$('#PisSpecList').datagrid('deleteRow',rowIndex);  //小于4时,删除该行后,在新增一个空行 qunianepng 2018/1/29
		rowNo -= 1;
		$("#PisSpecList").datagrid('appendRow',rowObj);
		
	}
	
	// 删除后,重新排序
	//$('#PisSpecList').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
	//删除后,根据标本序号重新排序,并重新编号
	sortTable();
}

/// 插入空行
function insRow(){
	
	if (isPageEditFlag == 0) return;	
	rowNo += 1;
	var rowObj = {"No":rowNo,"Name":"","Part":"","Qty":"","Remark":""};	
	$("#PisSpecList").datagrid('appendRow',rowObj);
}

/// 保存病理申请
function SavePisNo(){
	
	if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#PisSpecList").datagrid('endEdit', editSelRow); 
    }
    /*
    /// 医生站弹出界面时调用
	if (DocMainFlag == 1){
		InsertDoc();
		return;
	}
	*/
    
	var itmmastid = $("#TesItemID").val();  			   /// 医嘱项ID
	if (itmmastid == ""){
		$.messager.alert("提示:","请先选择病理检查项目！");
		return;
	}
	var recLocID = $HUI.combobox("#recLoc").getValue();    /// 接收科室ID
	var ApplyDocUser = $HUI.combobox("#ApplyDocUser").getValue();    /// 申请医生  qunianpeng 2018/2/5
	var ApplyLoc = $HUI.combobox("#ApplyLoc").getValue(); 			 /// 申请科室
	if(ApplyLoc==""){
		$.messager.alert("提示:","请先选择申请科室！");
		return;
	}
	if(ApplyDocUser==""){
		$.messager.alert("提示:","请先选择申请医生！");
		return;
	}
	var EmgFlag = ""; //$HUI.checkbox("#EmgFlag").getValue() ? "Y":"N";     /// 加急
	var FrostFlag = ""; //$HUI.checkbox("#FrostFlag").getValue() ? "Y":"N"; /// 冰冻
	//var mListData = itmmastid +"^"+ recLocID +"^"+  EpisodeID +"^"+ session['LOGON.USERID'] +"^"+ session['LOGON.CTLOCID'] +"^"+ EmgFlag +"^"+ FrostFlag +"^^^^^^APY";
	var mListData = itmmastid +"^"+ recLocID +"^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^^^^^^APY" +"^";
	
	/// 自发病至死亡病程时日
	var MorToDeaPro = $("#MorToDeaPro").val();
	/// 病史及治疗过程
	var DisAndTrePro = $("#DisAndTrePro").val();
	/// 临床体格检查及化验检查
	var PhyAndLabTest = $("#PhyAndLabTest").val();
	/// 解刨及处理方式
	var FinTakRes = "";
	if ($("#TakBack").is(':checked')){ FinTakRes = 1;}
	if ($("#TakHosp").is(':checked')){ FinTakRes = 2;}
	
	var mPatAutoPsy = MorToDeaPro +"^"+ DisAndTrePro +"^"+ PhyAndLabTest +"^"+ FinTakRes;

	/// 病理标本
	var PisSpecArr=[];
	var rowDatas = $('#PisSpecList').datagrid('getRows');
	$.each(rowDatas, function(index, item){
		if(trim(item.Name) != ""){
		    var TmpData = item.No +"^"+ item.ID +"^"+ item.Name +"^"+ item.Part +"^"+ item.Qty +"^"+ item.SliType +"^"+ item.PisNo +"^"+ item.Remark;
		    PisSpecArr.push(TmpData);
		}
	})
	var PisSpecList = PisSpecArr.join("@");
	if (PisSpecList == ""){
		$.messager.alert("提示:","标本内容不能为空！");
		return;	
	}
	
	///             主信息  +"&"+  尸检信息  +"&"+  病理标本
	var mListData = mListData +"&"+ mPatAutoPsy +"&"+ PisSpecList;

	/// 保存
	runClassMethod("web.DHCAppPisMaster","Insert",{"PisType":"APY", "PisID":PisID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","病理申请单发送失败，失败原因:"+jsonString);
		}else{
			PisID = jsonString;
			GetPisNoObj(PisID)
			$.messager.alert("提示:","保存成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
		}
	},'',false)
}

/// 发送病理申请
function SendPisNo(){

	/// 住院急诊留观押金控制
	var PatArrManMsg = GetPatArrManage();
	if (PatArrManMsg != ""){
		$.messager.alert("提示:",PatArrManMsg);
		return;	
	}
	
	/// 保存
	runClassMethod("web.DHCAppPisMaster","InsSendFlag",{"PisID":PisID},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","病理申请单已发送无需再次发送!");
		}else if (jsonString < 0){
			$.messager.alert("提示:","病理申请单发送失败，失败原因:"+jsonString);
		}else{
			GetPisNoObj(PisID);
			$.messager.alert("提示:","发送成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
			/// 电子病历框架函数
			window.parent.frames.InvEmrFrameFun();
		}
	},'',false)
}

/// 临时存储数据
function InsertDoc(){
	
	if ((editSelRow != -1)||(editSelRow == 0)) { 
        $("#PisSpecList").datagrid('endEdit', editSelRow); 
    }
    
	/// 医嘱项串
	var mItemParam = mListDataDoc.split("!")[1];
	if (mItemParam == "") return false;

	var ApplyDocUser = session['LOGON.USERID'];    /// 申请医生
	var ApplyLoc = session['LOGON.CTLOCID']; 	   /// 申请科室
	var EmgFlag = ""; 
	var FrostFlag = "";
	var mListData = "^^"+  EpisodeID +"^"+ ApplyDocUser +"^"+ ApplyLoc +"^"+ EmgFlag +"^"+ FrostFlag +"^^^^^^APY" +"^";
	
	/// 自发病至死亡病程时日
	var MorToDeaPro = $("#MorToDeaPro").val();
	/// 病史及治疗过程
	var DisAndTrePro = $("#DisAndTrePro").val();
	/// 临床体格检查及化验检查
	var PhyAndLabTest = $("#PhyAndLabTest").val();
	/// 解刨及处理方式
	var FinTakRes = "";
	if ($("#TakBack").is(':checked')){ FinTakRes = 1;}
	if ($("#TakHosp").is(':checked')){ FinTakRes = 2;}
	
	var mPatAutoPsy = MorToDeaPro +"^"+ DisAndTrePro +"^"+ PhyAndLabTest +"^"+ FinTakRes;

	/// 病理标本
	var PisSpecArr=[];
	var rowDatas = $('#PisSpecList').datagrid('getRows');
	$.each(rowDatas, function(index, item){
		if(trim(item.Name) != ""){
		    var TmpData = item.No +"^"+ item.ID +"^"+ item.Name +"^"+ item.Part +"^"+ item.Qty +"^"+ item.SliType +"^"+ item.PisNo +"^"+ item.Remark;
		    PisSpecArr.push(TmpData);
		}
	})
	var PisSpecList = PisSpecArr.join("@");
	if (PisSpecList == ""){
		window.parent.frames.InvErrMsg("【尸检申请】标本内容不能为空！");
		return false;	
	}
	
	///             主信息  +"&"+  尸检信息  +"&"+  病理标本
	var mListData = mListData +"&"+ mPatAutoPsy +"&"+ PisSpecList;

	/// 保存
	runClassMethod("web.DHCAppPisMaster","InsertTempDoc",{"Pid":pid, "mListData":mListData, "mItemParam":mItemParam},function(jsonString){
		if (jsonString < 0){
			window.parent.frames.InvErrMsg("【尸检申请】保存失败，失败原因:"+jsonString);
			return false;
		}
	},'',false)
					
	return true;
}

/// 加载病理申请主信息内容
function GetPisNoObj(PisID){
	
	runClassMethod("web.DHCAppPisMaster","JsGetPisNoObj",{"PisID":PisID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsPisNoObj(jsonObjArr);
		}
	},'json',false)
}

/// 设置病历申请单内容
function InsPisNoObj(itemobj){
	
	$("#TesItemID").val(itemobj.arcimid);
	$("#TesItemDesc").val(itemobj.ItemDesc);          /// 医嘱名称
	$("#recLoc").combobox("setValue",itemobj.LocID);  /// 接收科室
	$("#recLoc").combobox("setText",itemobj.LocDesc); /// 接收科室
	$HUI.checkbox("#EmgFlag").setValue(itemobj.EmgFlag == "Y"? true:false);      /// 加急
	$HUI.checkbox("#FrostFlag").setValue(itemobj.FrostFlag == "Y"? true:false);  /// 冰冻
	$HUI.datebox("#FoundDate").setValue(itemobj.FoundDate); /// 首次发现人乳头瘤病毒时间
									
	$HUI.combobox("#ApplyDocUser").setValue(itemobj.ApplyDocId);  /// 申请科室和申请医生 qunianpeng 2018/2/5
	$HUI.combobox("#ApplyDocUser").setText(itemobj.ApplyDocDesc);	
	$HUI.combobox("#ApplyLoc").setValue(itemobj.ApplyLocId);	
	$HUI.combobox("#ApplyLoc").setText(itemobj.ApplyLocDesc);
	
	/// 自发病至死亡病程时日
	$("#MorToDeaPro").val(itemobj.MorToDeaPro);
	/// 病史及治疗过程
	$("#DisAndTrePro").val(itemobj.DisAndTrePro);
	/// 临床体格检查及化验检查
	$("#PhyAndLabTest").val(itemobj.PhyAndLabTest);
	/// 解刨及处理方式
	if (itemobj.FinTakRes != ""){
		$HUI.checkbox("#" + itemobj.FinTakRes).setValue(true);
	}
	var SendPisFlag = itemobj.SendPisFlag;  /// 是否允许再次发送
	if (SendPisFlag == 1){
		$('a:contains("取消申请")').linkbutton('disable');
		$('a:contains("取消申请")').removeClass('btn-lightred');
		$('a:contains("发送")').linkbutton('disable');
		$('a:contains("发送")').removeClass('btn-lightgreen');
		$('a:contains("保存")').linkbutton('disable');
		$('a:contains("保存")').removeClass('btn-lightgreen');
		$('a:contains("打印")').linkbutton('disable');
		PageEditFlag(1);  /// 设置界面编辑状态
	}else if (SendPisFlag == 2){
		$('a:contains("发送")').linkbutton('disable');
		$('a:contains("发送")').removeClass('btn-lightgreen');
		$('a:contains("取消申请")').linkbutton('enable');
		$('a:contains("取消申请")').addClass('btn-lightred');
		$('a:contains("打印")').linkbutton('enable');
		PageEditFlag(2);  /// 设置界面编辑状态
	}else{
		$('a:contains("取消申请")').linkbutton('enable');
		$('a:contains("取消申请")').addClass('btn-lightred');
		$('a:contains("发送")').linkbutton('enable');
		$('a:contains("发送")').addClass('btn-lightgreen');
		$('a:contains("保存")').linkbutton('enable');
		$('a:contains("打印")').linkbutton('disable');
	}
	$("#Oeori").text(itemobj.Oeori);  /// 医嘱号
	$("#PisNo").text(itemobj.No);     /// 申请单号
}

/// 设置界面编辑状态
function PageEditFlag(Flag){
	
	$("#TesItemDesc").attr("disabled",true);   /// 医嘱描述
	$HUI.combobox("#recLoc").disable();        /// 接收科室不可用
	$HUI.combobox("#ApplyLoc").disable();      /// 申请科室不可用
	$HUI.combobox("#ApplyDocUser").disable();  /// 申请医生不可用
	$('input[type="checkbox"]').attr("disabled",true);
	$('textarea').attr("disabled", true);  /// 文本框
	$('.validatebox-text').attr("disabled", true); /// hisui 文本
	$('input[type="text"]').attr("disabled", true);
}

/// 病人就诊信息
function GetPatBaseInfo(){
	runClassMethod("web.DHCAppPisMasterQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "LocID":session['LOGON.CTLOCID'], "UserID":session['LOGON.USERID'] },function(jsonString){
		var jsonObject = jsonString;
		if (PisID == ""){
			
			/// 申请医生	
			$('#ApplyDocUser').combobox("setValue",session['LOGON.USERID']);
			$('#ApplyDocUser').combobox("setText",session['LOGON.USERNAME']);	
			
			/// 申请科室
			$('#ApplyLoc').combobox("setValue",session['LOGON.CTLOCID']); 
			$('#ApplyLoc').combobox("setText",jsonObject.LgLocDesc);		
		}

	},'json',false)
}

/// 是否允许填写尸检申请单
function GetIsWriteFlag(){
	
	if (PisID != "") return;
	runClassMethod("web.DHCAppPisMasterQuery","isPatDeadFlag",{"EpisodeID":EpisodeID},function(jsonString){
		
		isWriteFlag = jsonString;
		if(isWriteFlag != "Y"){
			$.messager.alert("提示:","仅有死亡患者才能填写尸检申请单！");
		}
	},'',false)
}


/// 加载检查方法列表
function LoadCheckItemListDoc(){
	
	var arcItemList=mListDataDoc.split("!")[1];

	/// 初始化检查方法区域
	$("#itemList").html('<tr style="height:0px;" ><td style="width:20px;"></td><td></td><td></td><td style="width:20px;"></td><td></td><td></td></tr>');
	runClassMethod("web.DHCAppPisMasterQuery","jsonExaItemListDoc",{"arcItemList":arcItemList},function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString
			InitCheckItemRegionDoc(jsonObjArr);
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegionDoc(itemArr){

	var itemhtmlArr = []; itemhtmlstr = "";
	for (var i=1; i<=itemArr.length; i++){
		itemhtmlArr.push('<td style="width:30px;">'+ i +'</td><td>'+ itemArr[i-1].text +'</td><td>'+ itemArr[i-1].desc +'</td>');
		if (i % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
 	if ((i-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(itemhtmlstr);

}

/// 打印病理申请单
function PrintPisNo(){
	
	PrintPis_REQ(PisID);
	return;
	
//	if (PisID == ""){
//		$.messager.alert("提示:","当前无可打印的病理申请单！");
//		return;
//	}
//	runClassMethod("web.DHCAPPPrintCom","GetPisPrintCon",{"PisID":PisID},function(jsonString){
//		
//		if (jsonString == null){
//			$.messager.alert("提示:","打印异常！");
//		}else{
//			var jsonObj = jsonString;
//			Print_Xml(jsonObj);
//		}
//	},'json',false)	
}

/// 尸检申请单打印
function Print_Xml(jsonObj){
	
	var MyPara = "";
	/// 申请单申请内容
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// 登记号
	MyPara = MyPara+"^PatNoBarCode"+String.fromCharCode(2)+"*"+jsonObj.Oeori+"*";  /// 登记号-条码
	MyPara = MyPara+"^BarCode"+String.fromCharCode(2)+jsonObj.Oeori;            /// 登记号-条码
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;	        /// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		    /// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;            /// 年龄
	MyPara = MyPara+"^BillType"+String.fromCharCode(2)+jsonObj.BillType;        /// 费别
	MyPara = MyPara+"^PatWard"+String.fromCharCode(2)+jsonObj.PatWard;       	/// 病区
	MyPara = MyPara+"^UserName"+String.fromCharCode(2)+jsonObj.UserName;    	/// 申请人
	MyPara = MyPara+"^ReqLoc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	    /// 申请科室
	MyPara = MyPara+"^CreatDate"+String.fromCharCode(2)+jsonObj.CreatDate;  	/// 创建日期
	MyPara = MyPara+"^PatTelH"+String.fromCharCode(2)+txtUtil(jsonObj.PatTelH); /// 检查项目
	MyPara = MyPara+"^PatAddr"+String.fromCharCode(2)+txtUtil(jsonObj.PatAddr); /// 检查项目
	
	/// 申请单明细内容
	MyPara = MyPara+"^PisReqNo"+String.fromCharCode(2)+txtUtil(jsonObj.PisReqNo);       	    /// 申请单号
	MyPara = MyPara+"^SpecName"+String.fromCharCode(2)+txtUtil(jsonObj.SpecName);       		/// 标本信息
	MyPara = MyPara+"^lbapplycheckpro"+String.fromCharCode(2)+txtUtil(jsonObj.CellOrder);  		/// 检查项目
	MyPara = MyPara+"^MorToDeaPro"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.MorToDeaPro,60));  		/// 自发病至死亡病程时日
	MyPara = MyPara+"^DisAndTrePro"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.DisAndTrePro,60));     	/// 病史及治疗经过
	MyPara = MyPara+"^PhyAndLabTest"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PhyAndLabTest,60)); 	/// 临床体格检查及化验检查
	MyPara = MyPara+"^PatDiagDesc"+String.fromCharCode(2)+txtUtil(autoWordEnterNew(jsonObj.PisTesDiag,60));  		/// 最后临床诊断
	
	MyPara = MyPara+"^TakBack"+String.fromCharCode(2)+(txtUtil(jsonObj.FinTakRes) == "TakBack"?"√":"");  		/// 由尸亲领回
	MyPara = MyPara+"^TakHosp"+String.fromCharCode(2)+(txtUtil(jsonObj.FinTakRes) == "TakHosp"?"√":"");  		/// 由院方处置
	MyPara = MyPara+"^GreenFlag"+String.fromCharCode(2)+txtUtil(jsonObj.GreenFlag);	   /// 绿色通道 sufan 2018-10-22 
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisAutoPsy");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, MyPara, "");
}

/// 撤销病理申请单
function RevPisNo(){
	
	runClassMethod("web.DHCAppPisMaster","revPisMain",{"PisID":PisID, "UserID":session['LOGON.USERID']},function(jsonString){

		if (jsonString == 0){
			GetPisNoObj(PisID);
			$.messager.alert("提示:","取消成功！");
			/// 调用父框架函数
		    window.parent.frames.reLoadEmPatList();
		}else if(jsonString == "-12"){   //sufan 2018-03-12
			$.messager.alert("提示:","已执行，不能取消申请！");
			}else{
			$.messager.alert("提示:","取消异常！");
		}
	},'',false)
}

/// 打印条码
function PrintPisBar(flag){
	
	window.parent.frames.PrintBar(PisID,flag)
	/*runClassMethod("web.DHCAPPPrintCom","GetPisPrintCon",{"PisID":PisID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			var jsonObj = jsonString;
			Print_BarCode(jsonObj);
		}
	},'json',false)	*/
}

/// 条码打印
function Print_BarCode(jsonObj){

	var MyPara = "";
	/// 申请单申请内容
	MyPara = "RegNo"+String.fromCharCode(2)+jsonObj.PatNo;					    /// 登记号
	MyPara = MyPara+"^lbbarcode"+String.fromCharCode(2)+"*"+jsonObj.PatNo+"*";  /// 登记号-条码
	MyPara = MyPara+"^lbpatname"+String.fromCharCode(2)+jsonObj.PatName;		/// 姓名
	MyPara = MyPara+"^lbpatsex"+String.fromCharCode(2)+jsonObj.PatSex;		    /// 性别
	MyPara = MyPara+"^lbpatage"+String.fromCharCode(2)+jsonObj.PatAge;          /// 年龄
	MyPara = MyPara+"^lblesion"+String.fromCharCode(2)+jsonObj.PatWard;       	/// 病区
	MyPara = MyPara+"^lbapplydoc"+String.fromCharCode(2)+jsonObj.UserName;    	/// 申请人
	MyPara = MyPara+"^lbapllyloc"+String.fromCharCode(2)+jsonObj.ReqLoc;      	/// 申请科室
	MyPara = MyPara+"^lbrecloc"+String.fromCharCode(2)+txtUtil(jsonObj.RecLoc); /// 接收科室
	MyPara = MyPara+"^lbapplydate"+String.fromCharCode(2)+jsonObj.CreatDate;  	/// 创建日期
	MyPara = MyPara+"^CreatTime"+String.fromCharCode(2)+jsonObj.CreatTime;    	/// 创建时间
	MyPara = MyPara+"^lbspecinfo"+String.fromCharCode(2)+txtUtil(jsonObj.SpecName);     	/// 标本
	MyPara = MyPara+"^lbapplycheckpro"+String.fromCharCode(2)+txtUtil(jsonObj.PisItem);     /// 检查项目

	//DHCP_GetXMLConfig("DHCAPP_PisBarCode");
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCAPP_PisBarCode");
	//调用具体打印方法
	//DHCP_PrintFun(MyPara, "");
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,MyPara,"");
}

/// 内容为 undefined 显示空
function txtUtil(txt){
	
	return (typeof txt == "undefined")?"":txt;
}

/// 申请单是否允许编辑
function InitReqEditFlag(ID){

	var LgParams = LgUserID +"^"+ LgCtLocID +"^"+ LgGroupID;
	runClassMethod("web.DHCAPPExaReportQuery","JsGetReqEditFlag",{"ID":ID, "Type":"P", "LgParams":LgParams},function(jsonString){
		if (jsonString != ""){
			isPageEditFlag = jsonString;
			PageBtEditFlag(jsonString);
		}
	},'',false)
}

/// 设置界面编辑状态
function PageBtEditFlag(Flag){

	if (Flag == 0){
		$('a:contains("取消申请")').linkbutton('disable');
		$('a:contains("取消申请")').removeClass('btn-lightred');
		$('a:contains("保存")').linkbutton('disable');
		$('a:contains("保存")').removeClass('btn-lightgreen');
	}
}

/// 加载申请单内容
function LoadReqFrame(PisID, repEmgFlag){

	GetPisNoObj(PisID);        /// 加载病理申请
	InitReqEditFlag(PisID);    /// 申请单是否允许编辑
	$("#PisSpecList").datagrid("load",{"PisID":PisID});  /// 标本列表
}
function InitPageCheckBox()
{
	///控制医嘱项单选  sufan 2018-01-30
	var tempckid="";
	//$("#itemList input[type='checkbox'][name='ExaItem']").click(function(){
	$("#itemList").on("click","[name='ExaItem']",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("#itemList input[type='checkbox'][name="+this.name+"]").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					}
				})
			
			}else{
					$("#TesItemID").val("");
					$("#TesItemDesc").val("");
					$("#recLoc").combobox("setValue","");
					$("#recLoc").combobox("setText","");
				}
		})
}

/// 验证病人是否允许开医嘱 住院急诊留观押金控制
function GetPatArrManage(){

	var PatArrManMsg = "";
	var amount = $("#arExaReqCost").text(); /// 金额
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCAPPExaReport","GetArrearsManage",{"EpisodeID":EpisodeID,"LgGroupID":LgGroupID,"LgLocID":LgCtLocID,"amount":amount},function(jsonString){

		if (jsonString != ""){
			PatArrManMsg = jsonString;
		}
	},'',false)

	return PatArrManMsg;
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	if (PisID != ""){
		LoadReqFrame(PisID, "");    /// 加载病理申请
		$("#itemList").hide();
	}
}
// 表格删除行后重新排序 qunianpeng  2018/1/29 
// 没有考虑完全 rowNo默认是4,若从加载过来标本后，则可不是4行
function sortTable(){
	var tmpNum = 1;
	var arr = [];
	var selItems = $('#PisSpecList').datagrid('getRows');
	console.log(selItems)
	$.each(selItems, function(index, item){
		//var tepObj = {"No":tmpNum ,"Name": item.Name,"Explain":item.Explain,"Part":item.Part,"Qty":item.Qty,"Remark":item.Remark,"SliType":item.SliType,"PisNo":item.PisNo};
		var tepObj = {"No":tmpNum,"Name":item.Name, "Part":item.Part, "Qty":item.Qty, "Remark":item.Remark};	
		tmpNum += 1;
		arr.push(tepObj);		
	});
	for (var i=0; i<arr.length; i++){	
		$('#PisSpecList').datagrid('updateRow',{index:i, row:arr[i]});		
	}
	rowNo = tmpNum-1; 	//记录最大的行号
  
}

window.onload = onload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
