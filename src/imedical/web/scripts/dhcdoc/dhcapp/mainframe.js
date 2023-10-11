//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-01-08
// 描述:	   新版检查一体化
//===========================================================================================

var PatientID = "";      /// 病人ID
var mradm = "";			 /// 就诊诊断ID
var EpisodeID = "";      /// 病人就诊ID
var arItemCatID = "";    /// 检查分类ID
var itemSelFlag = "";    /// 已选列表当前状态值
var mMainSrc = "E";
var arExaReqIdList = "";
var LgUserID = session['LOGON.USERID'];   /// 用户ID
var LgCtLocID = session['LOGON.CTLOCID']; /// 科室ID
var LgGroupID = session['LOGON.GROUPID']; /// 安全组ID
var LgHospID = session['LOGON.HOSPID'];   /// 医院ID
var repStatusArr = [{"value":"V","text":$g('核实')}, {"value":"D","text":$g('停止')}, {"value":"I","text":$g('待审核')}];
var PyType="";
var PatType="";   /// 就诊类型
var PracticeFlag=""
var NotBindLabFee="";	//检验不绑定费用标志,Y不绑定

/// 1、关闭当前弹窗并刷新医嘱页面(医生站)
/// 2、关闭当前弹窗(电子病历)
var CloseFlag = "";      /// 关闭标志

/// 数字签名相关
var IsCAWin = "";	  
var caIsPass = 0;
var ContainerName = "";
var BillTypeID = "";     /// 病人费别
var BillType = "";       /// 病人费别
var SendFlag = "";       /// 是否发送
var PPRowId = "";        /// 临床科研ID
var PPFlag = "";         /// 临床科研标识
var IsPatDead="";
var EmConsultItm="";     /// 会诊子表ID
var LeaveSelect="";		/// 离开界面事件选择标识

/// 页面初始化函数
function initPageDefault(){
		
	InitPatEpisodeID();   ///  初始化加载病人就诊ID
	initShowBillType();   ///  初始化病人费别
	initVersionMain();    ///  页面兼容配置
	initDataGrid();  	  ///  页面DataGrid初始定义

	initCombobox();       ///  页面Combobox初始定义
	initBlButton();       ///  页面Button绑定事件
	initCombogrid();      ///  页面Combogrid事件
	GetPatBaseInfo();     ///  加载病人信息BillType
		
	LoadPageBaseInfo();   ///  初始化加载基本数据
	initPatNotTakOrdMsg(); /// 验证病人是否允许开医嘱
	
	switchMainSrc("L","","","","");
	//初始化慢病病种LookUp
    InitChronicDiagLookUp();
	treeTypeClick();	  ///  快捷按钮点击事件响应
	if (RecLocByLogonLocFlag==1) {
		$("#FindByLogDep").checkbox("setValue",true);
	}
	GetIsPatDeadFlag();
}

function initShowBillType(){

	var billBtnHtml="";
	if (EpisodeID!="") {
		var billInfo = $.m({ClassName:"web.DHCAPPExaReportQuery",MethodName:"GetBillInfo",EpisodeID:EpisodeID,PPFlag:PPFlag,InHosp:session['LOGON.HOSPID']},false);
		BillTypeID=billInfo.split("^")[0];   /// 费别指针
		BillType=billInfo.split("^")[1];
		PatType=billInfo.split("^")[2];      /// 就诊类型
	}
	if((PPFlag=="Y")&&(BillTypeID=="")){
		$.messager.alert("提示","科研病人费别未配置,不能发送申请单！");
		return;
	}
	
	if(PPFlag=="Y"){
		 //billBtnHtml = billBtnHtml+"<li class='pf-nav-item-li item-li item-li-select' id='"+BillTypeID+"'><span>"+BillType+"</span></li>"
		billBtnHtml = billBtnHtml+" <li data-type='' id='"+BillTypeID+"' ><a href='#' >"+BillType+"</a></li>"
	}else{
		var PrescriptTypeStr = $.m({ClassName:"web.DHCDocOrderCommon",MethodName:"GetPrescriptTypeInfo",BillTypeID:BillTypeID,PAAdmType:PatType},false);
		var PrescriptTypeArr = PrescriptTypeStr.split("^");
		var PresTypes=PrescriptTypeArr[0]  /// 费别列表
		var DefTypes=PrescriptTypeArr[1]   /// 默认费别
		if (DefTypes!="") {
			BillTypeID=DefTypes.split(":")[0];
			BillType=DefTypes.split(":")[1];
		}
		InitInsurFlag(BillTypeID)
		
		var PresTypesArr = PresTypes.split(";");
		for(i in PresTypesArr){
		   var BillTypeList=PresTypesArr[i];
		   var TypeID=BillTypeList.split(":")[0];
		   var BillTypeDesc=BillTypeList.split(":")[1];
		   if(BillTypeList!=DefTypes){
			   //billBtnHtml = billBtnHtml+"<li class='pf-nav-item-li item-li' id='"+TypeID+"'><span>"+BillTypeDesc+"</span></li>";
			   billBtnHtml = billBtnHtml+" <li class='' id='"+TypeID+"'><a href='#' >"+BillTypeDesc+"</a></li>"
		   }else{
			  //billBtnHtml = billBtnHtml+"<li class='pf-nav-item-li item-li item-li-select' id='"+TypeID+"'><span>"+BillTypeDesc+"</span></li>"
			  billBtnHtml = billBtnHtml+" <li class='selected' id='"+TypeID+"' ><a href='#' >"+BillTypeDesc+"</a></li>"
		   }
		}
	}
	$("#billTyp").append(billBtnHtml);
	return;
}

function initShowPatInfo(){
	$.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:EpisodeID,PatientID:""},function(html){
		if (html!=""){
			$("#patInfo").html(reservedToHtml(html));
			$("#patInfo").mouseover(function(){
				html=reservedToHtml(html).replace(/color:#589DDA/g, "");
				layer.tips(html, '#patInfo', {
    				tips: [1, '#3595CC'],
    				area: ['800px', 'auto'],
    				time: 0
				});
			});
			$("#patInfo").mouseout(function(){
				layer.closeAll()
			});
		}else{
			$("#patInfo").html("获取病人信息失败。请检查【患者信息展示】配置。");
		}
	});
}

/**
* @author wanghc
* @date 2012/5/18
* @param {String} str
* @return {HTMLString} html html片段
*/
function reservedToHtml(str){	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}

/// 页面兼容配置
function initVersionMain(){

    initCheckPartTree();
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	EpisodeID = getParam("EpisodeID");
	PatientID = getParam("PatientID");
	mradm = getParam("mradm");
	CloseFlag = getParam("CloseFlag");
	PPRowId = getParam("PPRowId");    /// 临床病理ID
	PPFlag = PPRowId==""?"N":"Y";
	PracticeFlag=getParam("PracticeFlag");  
	EmConsultItm=getParam("EmConsultItm");
	NotBindLabFee=getParam("NotBindLabFee");
	if (ParaType!="SideMenu"){
		if(typeof InitPatInfoBanner){
			InitPatInfoBanner(EpisodeID,PatientID);
		}
	}
	ShowSecondeWin("onOpenDHCEMRbrowse");
}

///  初始化加载基本数据
function LoadPageBaseInfo(){
	
	/// 初始化树
	findExaItmTree();
	
}

/// 病人就诊信息
function GetPatBaseInfo(){
	runClassMethod("web.DHCAPPExaReportQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "PPFlag":PPFlag},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "男"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "女"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/unman.png");
			}
		})
		if (BillType == ""){
			BillTypeID = jsonObject.BillTypeID;  /// 费别ID
			BillType = jsonObject.BillType;  /// 费别
			InitInsurFlag(BillTypeID)
			
			
		}
		PatType = jsonObject.PatType;  		/// 就诊类型
	},'json',false)
}

/// 页面DataGrid初始定义
function initDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'PatLabel',title:'申请单',width:217,formatter:setCellLabel,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	        itemSelFlag = 1;  /// 已选列表当前状态值
			/// 申请单已选列表
	        var arRepID = rowData.arRepID;
	        var nodeType = rowData.TraType;
	        var repEmgFlag = rowData.repEmgFlag;
	       
		    if(nodeType != mMainSrc){
				switchMainSrc(nodeType, "", arRepID, repEmgFlag, rowData.ReqType);   ///添加加急标志  sufan
			}else{
				frames[0].LoadReqFrame(arRepID, repEmgFlag);
			}
			//mMainSrc = nodeType; /// 当前资源类型
	    },
		onLoadSuccess:function(data){
			///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            BindTips(); /// 绑定提示消息
		},
		rowStyler:function(index,rowData){   
	        if (rowData.repStatCode == "停止"){
	            return 'background-color:Pink;'; 
	        }
	    },
	    onRowContextMenu: function (e, rowIndex, rowData) { //右键时触发事件

           e.preventDefault(); //阻止浏览器捕获右键事件  
           $(this).datagrid("clearSelections"); //取消所有选中项  
           $(this).datagrid("selectRow", rowIndex); //根据索引选中该行  
           $('#menu').menu('show', {  
               //显示右键菜单  
               left: e.pageX,//在鼠标点击处显示菜单  
               top: e.pageY  
           });  
           e.preventDefault();  //阻止浏览器自带的右键菜单弹出 
        }
	};

	var params = EpisodeID +"^^^"+ LgHospID;
	if (PracticeFlag==1){
		var params = EpisodeID +"^^I^"+ LgHospID;
		}
	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqHisList&params="+params;
	new ListComponent('dgEmPatList', columns, uniturl, option).Init();
	
	///  隐藏刷新按钮
	$('#dgEmPatList').datagrid('getPager').pagination({ showRefresh: false}); 
	
	///  隐藏分页图标
    var panel = $("#dgEmPatList").datagrid('getPanel').panel('panel');  
    panel.find('.pagination-page-list').hide();
    panel.find('.pagination-info').hide()
}

/// 申请列表 卡片样式
function setCellLabel(value, rowData, rowIndex){
	
	var FontColor = "green";
	if (rowData.repStatCode == "停止"){
		FontColor = "red";
	}
	if (rowData.repStatCode=="待审核"){
		var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.arExaReqCode +'</h3><h4 style="float:left;padding-left:10px;background-color:transparent;">'+ rowData.arReqData+'</h4><h3 style="float:right;color:'+ FontColor +';background-color:transparent;"><span>'+ rowData.CreateDocDesc +'</span></h3><br>';	
	}else{
	var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.arExaReqCode +'</h3><h4 style="float:left;padding-left:10px;background-color:transparent;">'+ rowData.arReqData+'</h4><h3 style="float:right;color:'+ FontColor +';background-color:transparent;"><span>'+ rowData.repStatCode +'</span></h3><br>';
	
	}	/*
		htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">'+ rowData.arReqData +'</h4>';
		
		if (rowData.repStatCode != "停止"){
		    htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;"><span style="width:50%;padding-bottom: 0px;padding-top: 0px"><a href="#" onclick="showItmDetWin('+rowData.arRepID+')">预约</a>&nbsp;&nbsp;&nbsp;<a href="#" onclick="showItmRetWin('+rowData.Oeori+')">结果</a></span></h4>';
		}
		*/
		/// 循环拆分检查项目
		var TempList = rowData.arcListData;
		var TempArr = TempList.split("#");
		for (var k=0; k < TempArr.length; k++){
			var TempCArr = TempArr[k].split("&&");
			var TempCText=""; /// 项目全称
			if (!TempCArr[1]) continue
			if (TempCArr[1].length > 7){
				TempCText = TempCArr[1];					   /// 检查项目全称 用于提示
				TempCArr[1]=TempCArr[1].substring(0,6)+"...";  /// 检查项目仅显示7个字符
			}
			var FontColor = "";
/* 			if (TempCArr[2] == "IM"){ 
				FontColor="#FF69B4";    /// 检查项目有报告返回,显示红色字体
			} */

			htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;"><span style="width:50%;padding-bottom: 0px;padding-top: 0px;color:'+FontColor+'" name="'+TempCText+'">'+ TempCArr[1] +'</span></h4>';
			htmlstr = htmlstr + '<h4 style="float:right;background-color:transparent;padding-right: 10px;"><span style="width:50%;padding-bottom: 0px;padding-top: 0px" name="1">';
			/// 是否需要预约
			if (TempCArr[3] == "Y"){
				htmlstr = htmlstr + '<a href="#" onclick="showItmDetWin('+rowData.arRepID+')"><img src="../scripts/dhcnewpro/images/app.png"></a>';
			}
			if (TempCArr[2] == "IM"){ 
				htmlstr = htmlstr + '&nbsp;&nbsp;&nbsp;<a href="#" onclick="showItmRetWin(\''+TempCArr[0]+'\',\''+rowData.TraType+'\')"><img src="../scripts/dhcnewpro/images/result.png"></a>';
				
			}
			htmlstr = htmlstr + '</span></h4><br>';
		}
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}

/// 检查项目绑定提示栏
function BindTips(){
	
	var html='<div id="tip" style="border-radius:3px; display:none; border:1px solid #000; padding:10px;position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	/// 鼠标离开
	$('.celllabel h4 span').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// 鼠标移动
	$('.celllabel h4 span').on({
		'mousemove':function(){
			var tleft=(event.clientX + 20);
			if ($(this).attr("name").length <= 7){  //.text()
				return;
			}
			/// tip 提示框位置和内容设定
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.7
			}).text($(this).attr("name"));    // .text()
		}
	})
}

/// 复选框
function SetCellCheckBox(value, rowData, rowIndex){

	var html = '<input name="ItmCheckBox" type="checkbox" value='+rowIndex+'></input>';
    return html;
}

/// 初始化检查部位树
function initCheckPartTree(){

	var url = ""; //$URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCat&HospID='+LgHospID;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	       
	        var isLeaf = $("#CheckPart").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        var itemCatID = node.id;         /// 检查分类ID
		        var itemCatCode = node.code;     /// 检查分类代码
				//LoadCheckItemList(itemCatID);  /// 加载检查方法列表
			    var nodeType = GetNodeType(itemCatID);
		        if (nodeType != mMainSrc){
			    	switchMainSrc(nodeType, itemCatID, "", "", itemCatCode);
			    }else{
					frames[0].LoadCheckItemList(itemCatID);
				}
	        }else{
		       	var itemCatID = node.id;         /// 检查分类ID
		        var itemCatCode = node.code;     /// 检查分类代码
		        var nodeType = GetNodeType(itemCatID);
		        if ((nodeType != mMainSrc)&(nodeType != "P")){
		        	switchMainSrc(nodeType, itemCatID, "", "", itemCatCode);
		        }
		    	$("#CheckPart").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
		    }
	    },
	    onExpand:function(node, checked){
		 
			var childNode = $("#CheckPart").tree('getChildren',node.target)[0];  /// 当前节点的子节点
	        var isLeaf = $("#CheckPart").tree('isLeaf',childNode.target);        /// 是否是叶子节点
	        if (isLeaf){
		        var itemCatID = node.id;         /// 检查分类ID
		        var itemCatCode = node.code;     /// 检查分类代码
		        var nodeType = GetNodeType(itemCatID);
		        if (nodeType == "P") return;
		        if (nodeType != mMainSrc){
		        	switchMainSrc(nodeType, itemCatID, "", "", itemCatCode);
		        }else{
					frames[0].LoadCheckItemList(itemCatID);  /// 加载检查方法列表
		        }
	        }
		}
	};
	new CusTreeUX("CheckPart", '', option).Init();
}

/// 页面Combobox初始定义
function initCombobox(){

	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=";

	/// 检查分类
	var option = {
        onSelect:function(option){

	        var arItemCatID = option.value; /// 检查分类ID
			
	        var repStatusID = $("#repStatus").combobox('getValue'); /// 报告状态
	        if (typeof repStatusID == "undefined"){
		    	repStatusID = "";
		    }
	        var tmpEpisodeID = $('#AdmHis').combogrid('getValue');  /// 就诊ID
	        if ((typeof tmpEpisodeID == "undefined")||(tmpEpisodeID=="")){
		    	tmpEpisodeID = EpisodeID;   
		    }
			var params = tmpEpisodeID +"^"+ arItemCatID +"^"+ repStatusID +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue != ""){
		    	return;
		    }
		    var repStatusID = $("#repStatus").combobox('getValue'); /// 报告状态
	        if (typeof repStatusID == "undefined"){
		    	repStatusID = "";
		    }
	        var tmpEpisodeID = $('#AdmHis').combogrid('getValue');  /// 就诊ID
	        if ((typeof tmpEpisodeID == "undefined")||(tmpEpisodeID=="")){
		    	tmpEpisodeID = EpisodeID;   
		    }
			var params = tmpEpisodeID +"^"+ "" +"^"+ repStatusID +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    }
	};
	var url = uniturl+"jsonExaCat&HospID="+LgHospID;
	new ListCombobox("itemCatID",url,'',option).init();
	
	/// 报告状态
	var option = {
		panelHeight:"auto",
        onSelect:function(option){

	        var repStatusID = option.value; /// 报告状态Code
			var itemCatID = $("#itemCatID").combobox('getValue'); /// 检查分类ID
			if (typeof itemCatID == "undefined"){
		    	itemCatID = "";
		    }
			var tmpEpisodeID = $('#AdmHis').combogrid('getValue');
			if ((typeof tmpEpisodeID == "undefined")||(tmpEpisodeID=="")){
		    	tmpEpisodeID = EpisodeID;
		    }
	        /// 检查方法
			var params = tmpEpisodeID +"^"+ itemCatID +"^"+ repStatusID +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    },
	    onChange:function(newValue, oldValue){
	    	if (newValue != ""){
		    	return;
		    }
			var itemCatID = $("#itemCatID").combobox('getValue'); /// 检查分类ID
			if (typeof itemCatID == "undefined"){
		    	itemCatID = "";
		    }
			var tmpEpisodeID = $('#AdmHis').combogrid('getValue');
			if ((typeof  tmpEpisodeID == "undefined")||(tmpEpisodeID=="")){
		    	tmpEpisodeID = EpisodeID;
		    }
	        /// 检查方法
			var params = tmpEpisodeID +"^"+ itemCatID +"^"+ "" +"^"+ LgHospID;
			$("#dgEmPatList").datagrid("load",{"params":params});
	    }
	};
	new ListCombobox("repStatus",'',repStatusArr,option).init();
	if (PracticeFlag==1){
		 $HUI.combobox("#repStatus").setValue("I"); 
		}
}

/// 页面 Button 绑定事件
function initBlButton(){
	
	///  拼音码
	$("#ExaItmCode").bind("keypress",findExaItemList);
	
	///  拼音码
	$("#ExaCatCode").bind("keyup",findExaItmTree);

	/// 费别类型事件
	//$("#billTyp").bind("click",BillTypeEvt);
	$("#billTyp.kw-section-list>li").click(function(){
		var LeaveFlag=true;
		if (LeaveFlag){	
			var btnObj = $(this);
			$("#billTyp.kw-section-list>li").removeClass('selected');
			btnObj.addClass('selected');
			BillTypeID =  this.id;       /// 费别ID 
			BillType = $(this).text();   /// 费别
			InitInsurFlag(BillTypeID)
			
		}else{
		}				
	});	
}

/// 费别类型事件
function BillTypeEvt(){
	
	$("#"+this.id).addClass("item-li-select").siblings().removeClass("item-li-select");
	BillTypeID =  this.id;       /// 费别ID 
	BillType = $(this).text();   /// 费别
	InitInsurFlag(BillTypeID)
	
}

/// 初始化病人历史就诊记录
function initCombogrid(){
	
	var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonPatAdmHisList&EpisodeID='+EpisodeID+"&HospId="+LgHospID;
	
	///  定义columns
	var columns=[[
		{field:'EpisodeID',title:'EpisodeID',width:100},
		{field:'itmLabel',title:'就诊内容',width:100,hidden:true},
		{field:'AdmDate',title:'就诊日期',width:100},
		{field:'AdmLoc',title:'接收科室',width:100},
		{field:'AdmDoc',title:'医生',width:100},
		{field:'PatDiag',title:'诊断',width:300}
	]];
	
	$('#AdmHis').combogrid({
		url:url,
		editable:false,    
	    panelWidth:550,
	    idField:'EpisodeID',
	    textField:'itmLabel',
	    columns:columns,
	    pagination:true,
        onSelect: function (rowIndex, rowData) {
	        
	        var repStatusID = $("#repStatus").combobox('getValue'); /// 报告状态
	        if (typeof repStatusID == "undefined"){
		    	repStatusID = "";
		    }
	        var itemCatID = $("#itemCatID").combobox('getValue');   /// 检查分类ID
	        if (typeof itemCatID == "undefined"){
		    	itemCatID = "";
		    }
	        /// 检查方法
			var params = rowData.EpisodeID +"^"+ itemCatID +"^"+ repStatusID +"^"+ LgHospID;
            $("#dgEmPatList").datagrid("reload",{"params":params});   /// 刷新页面数据
            
            /// 切换就诊记录时,同时刷新申请单内容区
            switchMainSrc("E","","","","");
            ShowSecondeWin("onOpenDHCEMRbrowse");
        }
	});
}

/// 查询检查项目
function findExaItemList(event){
	
	if(event.keyCode == "13"){
		var ExaItmCode=$.trim($("#ExaItmCode").val());
		var PyCode=$.trim($("#ExaCatCode").val());	
		var node = $("#CheckPart").tree('getSelected');	
		var isLeaf = $("CheckPart").tree('isLeaf',node.target);   /// 是否是叶子节点		
	    if (isLeaf){
	        var params = node.id +"^"+ "" +"^"+ ExaItmCode;
			$("#ItemList").datagrid("load",{"params":params});
        }
	}
}

/// 查找检查项目树
function findExaItmTree(event){
	
	var PyCode=$.trim($("#ExaCatCode").val());	
	if ((PyCode=="")&&(event)) {PyCode=event}
	if ((PyCode == "")&&(PyType == "")){
		<!-- 新旧版本兼容配置 -->
	    if (version != 1){
			/// 旧版
			if (expFlag==1) {
				//TODO
				var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatOld&HospID='+LgHospID;
			}else{
				var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeID&id=0&HospID='+LgHospID+'&PyType='+PyType;
			}
		}else{
			/// 新版
			if (expFlag==1) {
				var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCat&HospID='+LgHospID+"&LocID="+LgCtLocID;
			}else{
				var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByNodeIDNew&id=0&HospID='+LgHospID+'&PyType='+PyType+"&LocID="+LgCtLocID;;
			}
		}
	}else{			
		//$(".treetype li").removeClass('active');					//输入框检索时，快捷按钮失效 qunianpeng 2018/2/1
		//PyType = ""; 				
		<!-- 新旧版本兼容配置 -->
	    if (version != 1){
		    /// 旧版
			var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCode&PyCode='+PyCode+'&HospID='+LgHospID+'&PyType='+PyType+"&LocID="+LgCtLocID;;
		}else{
			/// 新版
			var url = $URL+'?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonCheckCatByPyCodeNew&PyCode='+PyCode+'&HospID='+LgHospID+'&PyType='+PyType+"&LocID="+LgCtLocID;;
		}
	}
	
	$('#CheckPart').tree('options').url =encodeURI(url);
	$('#CheckPart').tree('reload');
}

/// 验证病人是否允许开医嘱
function initPatNotTakOrdMsg(){
	
	var TakOrdMsg = GetPatNotTakOrdMsg();
	if (TakOrdMsg != ""){
		$.messager.alert("提示:",TakOrdMsg,"warning");
		return;	
	}
}

/// 验证病人是否允许开医嘱
function GetPatNotTakOrdMsg(){
	var NotTakOrdMsg = "";
	/// 验证病人是否允许开医嘱
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgCtLocID,"EpisodeID":EpisodeID,"EmConsultItm":EmConsultItm},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
}

/// 切换调用
function switchMainSrc(TypeFlag, itemCatID, arRepID, repEmgFlag, itemCatCode){
	
	var LinkUrl = "";
	if (TypeFlag == "E"){
		LinkUrl = "dhcapp.reportreq.csp?EpisodeID="+ EpisodeID +"&itemCatID="+itemCatID +"&repEmgFlag="+repEmgFlag+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;
		//在新页面的window.onload 对mMainSrc 进行赋值，防止连续两次点击检查的子类第二次点击页面加载错误
		//mMainSrc = TypeFlag; /// 当前资源类型
	}else if (TypeFlag == "L"){
		LinkUrl = "dhcapp.labreportreq.csp?EpisodeID="+ EpisodeID +"&itemCatID="+itemCatID +"&repEmgFlag="+repEmgFlag+"&itemReqID="+arRepID+"&PatType="+PatType+"&EmConsultItm="+EmConsultItm;
		//mMainSrc = TypeFlag; /// 当前资源类型
		LinkUrl+='&NotBindLabFee='+NotBindLabFee;
	}else if (TypeFlag == "P"){
		/// 取病理类型代码
		if (arRepID == ""){
			itemCatCode = GetPisTypeCode(itemCatID);
			if (itemCatCode == ""){
				$.messager.alert("提示","取病理类型代码出错,可能原因：检查分类和医嘱未进行关联！");
				return;
			}
		}
		
		if (itemCatCode == "HPV"){
			LinkUrl = "dhcapp.pismaster.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "CYT"){
			LinkUrl = "dhcapp.piscytexn.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "MOL"){
			LinkUrl = "dhcapp.pismolecular.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "CON"){
			LinkUrl = "dhcapp.pisoutcourt.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "TCT"){
			LinkUrl = "dhcapp.piswontct.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "APY"){
			LinkUrl = "dhcapp.pisautopsy.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}
		else if (itemCatCode == "LIV"){
			LinkUrl = "dhcapp.pislivcells.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&EmConsultItm="+EmConsultItm;	
		}else{
			LinkUrl = "docapp.blmapshow.hui.csp?&EpisodeID=" +EpisodeID+"&itemReqID="+arRepID+"&MapCode="+itemCatCode+"&EmConsultItm="+EmConsultItm;	
		}
		mMainSrc = itemCatCode; /// 当前资源类型
	}
	if (LinkUrl != ""){
		if(typeof websys_writeMWToken=='function') LinkUrl=websys_writeMWToken(LinkUrl);
		$("#TabMain").attr("src", LinkUrl);
	}
}

/// 获取节点类型
function GetNodeType(ID){
	
	var nodeType = "";
	runClassMethod("web.DHCAPPExaReportQuery","GetNodeType",{"ID":ID},function(jsonString){
		nodeType = jsonString;
	},'',false)
	return nodeType;
}

/// 取病理分类类型代码
function GetPisTypeCode(itemCatID){
	
	var PisTypeCode = "";
	runClassMethod("web.DHCAPPExaReportQuery","GetPisTypeCode",{"itemCatID":itemCatID},function(jsonString){
		PisTypeCode = jsonString;
	},'',false)
	return PisTypeCode;
}

/// 重新加载病人列表
function reLoadEmPatList(){
	SendFlag = 1;   /// 是否发送
	$("#dgEmPatList").datagrid("reload");   /// 刷新页面数据
	if (CloseFlag == 1){
		websys_showModal('options').CallBackFunc(SendFlag);
	}
	if (parent.UpdateTabsTilte) {
		parent.UpdateTabsTilte();
	}
}

/// 调用函数，刷新主框架内容和参数
function InvMainFrame(){
	SendFlag = 1;   /// 是否发送
	$("#dgEmPatList").datagrid("reload");   /// 刷新页面数据
	if (CloseFlag == 1){
		websys_showModal('options').CallBackFunc(SendFlag);
	}
}

/// 项目明细
function showItmDetWin(arRepID){
	
	showItmAppDetWin(arRepID);  /// 预约详情窗口
}

/// 检查结果
function showItmRetWin(Oeori, TraType){

	showItmAppRetWin(Oeori, TraType);        /// 检查结果
}

/// 申请日志
function MoreInfo(){

	LogPopUpWin();
}

/// 申请日志窗体
function LogPopUpWin(){
	
	var option = {
		modal:true,
	    collapsible:false,
	    minimizable:false,
	    maximizable:false,
	    onBeforeClose:function(){
			$("#dmLogList").datagrid('loadData',{total:0,rows:[]}); /// 清空datagrid
		}
	}
	/// 调用医嘱项列表窗口
	new WindowUX("申请日志","PopUpWin", "900", "300" , option).Init();
	InitLogList();
}

/// 初始化申请日志列表
function InitLogList(){
	
	///  定义columns
	var columns=[[
		{field:'ItmID',title:'ItemID',width:80,hidden:true},
		{field:'ItmStatus',title:'状态',width:100,align:"center"},
		{field:'ItmDate',title:'日期',width:100,align:"center"},
		{field:'ItmTime',title:'时间',width:100,align:"center"},
		{field:'ItmUser',title:'操作员',width:100,align:"center"},
		{field:'ItmReason',title:'撤销/申请部位信息',width:200}, //备注
		{field:'ItemDesc',title:'医嘱名称',width:200} 
	]];
	
	///  定义datagrid
	var option = {
		border : false,
		rownumbers : true,
		singleSelect : true,
		pagination: false
	};
	
	var ID = ""; var TraType = "";
	var rowData = $('#dgEmPatList').datagrid('getSelected');
	if (rowData){
		ID = rowData.arRepID;
		TraType = rowData.TraType;
	}

	var uniturl = $URL+"?ClassName=web.DHCAppPisMasterQuery&MethodName=GetAppLogList&AppID="+ID+"&TraType="+TraType;
	new ListComponent('dmLogList', columns, uniturl, option).Init();
}

/// 快捷按钮通过类型检索树  qunianpeng 2018/2/1
function treeTypeClick(){
	
	$("#Typelist.kw-section-list>li").removeClass("selected").filter("[data-type='E,L,P']").addClass("selected");
	$("#Typelist.kw-section-list>li").click(function(){
		var LeaveFlag=true;
		if (typeof(window.frames['TabMain'].onbeforeunload_handler) === 'function') {
			var UnSaveData=window.frames['TabMain'].onbeforeunload_handler();
			if (UnSaveData){
				LeaveFlag=dhcsys_confirm('有未保存的数据，是否确认切换？');
				LeaveSelect="Y";
			}
		}
		if (LeaveFlag){	
			var btnObj = $(this);
			$("#Typelist.kw-section-list>li").removeClass('selected');
			btnObj.addClass('selected');
			PyType = btnObj.data("type");		
			findExaItmTree(); 
			if (PyType=="E"){
				switchMainSrc("E","","","","");
			}else if (PyType=="L"){
				switchMainSrc("L","","","","");	
			}	
		}else{
			LeaveSelect="";
		}				
	});	
}

/// 检查申请弹出部位窗体
function OpenPartWin(arExaCatID,arExaItmID,GlobaPartID,EpisodeID){
	
	if($('#nPartWin').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="nPartWin"></div>');

	/// 预约详情窗口
	var option = {
		collapsible:true,
		border:true,
		closed:true,
		modal:true,
	    collapsible:false,
	    minimizable:false,
	    maximizable:false,
	    onBeforeClose:function(){
			frames[0].clrItmChkFlag();   	  ///  取消检查项目选中状态
		}
	};
	if(!EpisodeID) EpisodeID="";
	var linkUrl = "dhcapp.appreppartwin.csp?itmmastid="+arExaItmID +"&arExaCatID="+ arExaCatID +"&InvFlag=1"+"&GlobaPartID="+GlobaPartID+"&EpisodeID="+EpisodeID;
	var iframe='<iframe scrolling="no" width=100% height=558px  frameborder="0" src="'+linkUrl+'"></iframe>';
	new WindowUX('附加信息', 'nPartWin', '1200', '600', option).Init();
	
	$("#nPartWin").html(iframe);
}

/// 检查申请部位窗体确定回调函数
function closeWin(){
	
	frames[0].closeWin();
	$("#nPartWin").window("close");
}

/// 添加项目到已选列表
function InsItemSelList(rows, arExaDispID, arExaDispDesc){
	
	frames[0].InsItemSelList(rows, arExaDispID, arExaDispDesc);
	$("#nPartWin").window("close");
}

/// 调用框架接口函数【门诊需要调用接口，把医嘱插入到病历中】
function InvEmrFrameFun(){

	if (PatType != "I"){
		runClassMethod("web.DHCOEOrdItem","GetOrderDataToEMR",{"EpisodeID":EpisodeID},function(string){
			if (string != ""){
				InvokeChartFun(string);
			}
		},'',false)
	}
}

/// 调用框架接口函数
function InvokeChartFun(string){
	
	var TabName = "门诊病历";
	if (PatType == "E"){ TabName = "门急诊病历记录"; }
	var win1 = null;
	try{
		win1 = window.top.opener.frames['TRAK_main'];
	}catch(ex){
		win1 = window.top.opener.frames('TRAK_main');
	}
	if (!win1){
		//双击录入
		try{
			win1 = window.top.opener.top.frames["TRAK_main"];
		}catch(ex){
			win1 = window.top.opener.top.frames('TRAK_main');
		}
	}
	if(win1){
		win1.invokeChartFun(TabName,"updateEMRInstanceData","oeord",string);
	}
}

/// 弹出诊断窗口
function DiagPopWin(){
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
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

/// 医嘱的性别/年龄限制
function GetItmLimitMsg(arExaItmID){
	
	var LimitMsg = 0;
	var itmmastid = arExaItmID.replace("_","||");
	/// 医嘱的性别/年龄限制
	runClassMethod("web.DHCAPPExaReport","GetItmLimitMsg",{"EpisodeID":EpisodeID, "itmmastid":itmmastid},function(jsonString){

		LimitMsg = jsonString;
	},'',false)
	
	return LimitMsg;
}
function InitChronicDiagLookUp(){
	if (PatType =="I") {
		$("#ChronicDiag").hide();
		return;
	}
	if ($("#ChronicDiag").length==0){return}
	$("#ChronicDiag").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Code',
        textField:'Desc',
        columns:[[  
       		{field:'Desc',title:'描述',width:130,sortable:true}
        	,{field:'Code',title:'编码',hidden:true}
        	,{field:'Type',title:'类型',width:80,sortable:true}
        ]],
        width:95,
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocQryOEOrder',QueryName: 'LookUpChronicDiag'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{desc:desc,EpisodeID:EpisodeID});
	    }
	});
	$("#ChronicDiag").keyup(function(){
		if ($(this).val()==""){
			$(this).lookup("setValue","").lookup("setText","");
		}
	});
}
function GetChronicDiagCode(){
	if (PatType =="I") return "";
	var ChronicDiagCode="";
	if ($("#ChronicDiag").length>0){
		if ($("#ChronicDiag").lookup("getText")!=""){
			ChronicDiagCode=$("#ChronicDiag").lookup("getValue")
		}
	}
	if (typeof ChronicDiagCode=="undefined"){
		ChronicDiagCode="";
	}
	return ChronicDiagCode;
}
/// ==============================================以下CA数字签名=============================================

/// CA数字签名 获取用户list  bianshuai 2018-03-17 标版无设备，需现场进行测试
function GetList_pnp(){
	
	if (CAInit == 1){
		var strTemp =GetUserList();
		if (strTemp!="") IsCAWin=strTemp;
		else IsCAWin="";
	}
}

/// 数字签名 开申请调用
function TakeDigSign(mReqID, Type, UpdateObj){
	if (UpdateObj.caIsPass==1){
	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqOeori",{"mReqID":mReqID, "Type":Type},function(jsonString){

		if (jsonString != ""){
			//InsDigitalSign(jsonString, "A");  /// 调用数字签名
			if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, jsonString, "A");
		}
	},'',false)
	}
}


/// 数字签名 撤销申请
function TakeDigSignRev(mReqID, Type,UpdateObj){
	if (UpdateObj.caIsPass==1){
	runClassMethod("web.DHCAPPExaReportQuery","GetRevOeori",{"mReqID":mReqID, "Type":Type},function(jsonString){

		if (jsonString != ""){
			if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, jsonString, "S");
		}
	},'',false)
	}
}


/// CA数字签名认证函数
function InsDigitalSign(mOrditmData, XmlType){
	
    try {
        //1.批量签名认证
		var itmValData = ""; var itmHashData = ""; var itmSignData = "";
		var mOrditmArr = mOrditmData.split("^");
		for (var i=0; i < mOrditmArr.length; i++){
			/// 医嘱信息串
			var itmsXml = GetOrdItemXml(mOrditmArr[i], XmlType);
			var itmXmlArr = itmsXml.split(String.fromCharCode(2));
			for (var j = 0; j < itmXmlArr.length; j++) {
				if (itmXmlArr[j] == "") continue;
				var itmXml = itmXmlArr[j].split(String.fromCharCode(1))[1];
                var itmOpType = itmXmlArr[j].split(String.fromCharCode(1))[0];
                var itmXmlHash = HashData(itmXml);
                /// 签名串Hash值
                if (itmHashData == "") itmHashData = itmXmlHash;
                else itmHashData = itmHashData + "&&&&&&&&&&" + itmXmlHash;
                /// 签名串
                var SignedData = SignedOrdData(itmXmlHash, ContainerName);
                if (itmSignData == "") itmSignData = SignedData;
                else itmSignData = itmSignData + "&&&&&&&&&&" + SignedData;
                
                if (itmValData == "") itmValData = itmOpType + String.fromCharCode(1) + mOrditmArr[i];
                else itmValData = itmValData + "^" + itmOpType + String.fromCharCode(1) + mOrditmArr[i];
			}
		}
		
        if (itmHashData != "") itmHashData = itmHashData + "&&&&&&&&&&";
        if (itmSignData != "") itmSignData = itmSignData + "&&&&&&&&&&";

        //获取客户端证书
        var varCert = GetSignCert(ContainerName);
        var varCertCode = GetUniqueID(varCert);
        
        //3.保存签名信息记录
        if ((itmValData != "") && (itmHashData != "") && (varCert != "") && (itmSignData != "")) {
            var ret = InsBatchSign(itmValData, session['LOGON.USERID'], XmlType, itmHashData, varCertCode, itmSignData);
            if (ret != "0") $.messager.alert("警告", "数字签名没成功");
        } else {
            $.messager.alert("警告", "数字签名错误");
        }
    }catch(e){
	    $.messager.alert("警告", e.message);
    }
}

/// 取医嘱信息串
function GetOrdItemXml(Oeori, XmlType){
	
	var OrdItemXml = "";
	runClassMethod("web.DHCDocSignVerify","GetOEORIItemXML",{"newOrdIdDR":Oeori, "OperationType":XmlType},function(jsonString){
		OrdItemXml = jsonString;
	},'',false)
	return OrdItemXml;
}

/// 保存签名
function InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData){
	
	var retFlag = "";
	runClassMethod("web.DHCDocSignVerify","InsertBatchSignRecord",{"CurrOrderItemStr":itmValData, "UserID":LgUserID, "OperationType":XmlType, "OrdItemsHashVal":itmHashData,
	    "MainSignCertCode":varCertCode, "MainSignValue":itmSignData, "ExpStr":""},function(jsonString){
		
		retFlag = jsonString;
	},'',false)
	return retFlag;
}

/// 数字签名检查
function isTakeDigSign(){
	
    var caIsPass = 0;
    //var ContainerName = "";
    if (CAInit == 1){
        if (IsCAWin == "") {
            $.messager.alert("警告", "请先插入KEY");
            return false;
        }
        //判断当前key是否是登陆时候的key
        var resultObj = dhcsys_getcacert();
        var result = resultObj.ContainerName;
        if ((result == "") || (result == "undefined") || (result == null)) {
            return false;
        }
        ContainerName = result;
        caIsPass = 1;
    }
    return true;
}
function GetIsPatDeadFlag(){
	IsPatDead=$.cm({
		ClassName:"web.DHCAppPisMasterQuery",
		MethodName:"isPatDeadFlag",
		dataType:"text",
		EpisodeID:EpisodeID
	},false);
	return;
}
/// ==============================================以上CA数字签名=============================================

///修改医保标识默认值 统一到一个方法里面
function InitInsurFlag(BillTypeID){
	runClassMethod("web.DHCDocOrderCommon","GetDefInsurFlag",{"BillType":BillTypeID, "PAAdmType":""},function(jsonString){
			if (jsonString=="1"){
				$HUI.checkbox("#InsurFlag").setValue(true)
			}else{
				$HUI.checkbox("#InsurFlag").setValue(false)
				}
		},'',false)	
	
}

/// 展示第二副屏
function ShowSecondeWin(Flag){
    if (websys_getAppScreenIndex()==0){
	    var Obj={PatientID:PatientID,EpisodeID:EpisodeID,mradm:mradm};
	    if (Flag=="onOpenIPTab"){
		    //信息总览
		}
		if (Flag=="onOpenDHCEMRbrowse"){
			var JsonStr=$.m({
				ClassName:"DHCDoc.Util.Base",
				MethodName:"GetMenuInfoByName",
				MenuCode:"DHC.Seconde.DHCEMRbrowse"
			},false)
			if (JsonStr=="{}") return false;
			var JsonObj=JSON.parse(JsonStr);
			$.extend(Obj,JsonObj);
		}
		websys_emit(Flag,Obj);
	}
}

/// 页面关闭之前调用
function onbeforeunload_handler() {

    if (CloseFlag == 1){
		window.returnValue = SendFlag;
	}
	//解除患者锁
    tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock");
}
window.onbeforeunload = onbeforeunload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })