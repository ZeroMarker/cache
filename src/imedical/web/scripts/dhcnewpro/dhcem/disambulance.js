//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-10-26
// 描述:	   急诊科救护车派车管理
//===========================================================================================

var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var ItemTypeArr = [{"value":"N","text":'院内'}, {"value":"Y","text":'院外'}];;

/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化病人基本信息
	InitPatInfoPanel();
	
	/// 初始化加载病人列表
	InitPatList();
	
	QryDisAmbMan() //查询
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-7));
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// 急诊科室
	$HUI.combobox("#RLoc",{
		//url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
		url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType=EMLOC&LocID=&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// 类型
	var option = {
		panelHeight:"auto",
        onSelect:function(option){
	    }
	};
	var url = "";
	new ListCombobox("MtType",url,ItemTypeArr,option).init();
	
	var url = "";
	new ListCombobox("mMtType",url,ItemTypeArr,option).init();
	//$HUI.combobox("#mMtType").setValue("N");
	
	/// 登记号
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	$("#aPatNo").bind('keypress',PatNo_KeyPress_CD);
	$("#aPatName").bind('keypress',PatName_KeyPress_CD);
	
	
	//医生
	$HUI.combobox("#DocArr",{
		url: $URL+"?ClassName=web.DHCEMDisAmbMan&MethodName=JsonCareProv&ProvType=DOC&LgHospID="+LgHospID,
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	//护士
	$HUI.combobox("#NurArr",{
		url: $URL+"?ClassName=web.DHCEMDisAmbMan&MethodName=JsonCareProv&ProvType=NUR&LgHospID="+LgHospID,
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	
	///  定义columns
	var columns=[[
		{field:'MaID',title:'ID',width:100,hidden:false},
		{field:'PatNo',title:'登记号',width:120,align:'center',hidden:false},
		{field:'PACStaDesc',title:'病人状态',width:120,align:'center',hidden:false},
		{field:'PatName',title:'姓名',width:120,align:'center'},
		{field:'PatSex',title:'性别',width:100,align:'center'},
		{field:'PatAge',title:'年龄',width:100,align:'center'},
		{field:'VisPlace',title:'出诊地点',width:120},
		{field:'VisRea',title:'出诊事由',width:260},
		{field:'VisDate',title:'接通知日期',width:100,align:'center'},
		{field:'VisTime',title:'接通知时间',width:100,align:'center'},
		{field:'RecUser',title:'接通知者',width:100,align:'center'},
		{field:'PatLoc',title:'就诊科室',width:120 ,hidden:true},
		{field:'RDate',title:'派车日期',width:140,align:'center'}, 
		{field:'MtType',title:'类型',width:100,align:'center'},
		{field:'MtNotes',title:'备注',width:260},
		{field:'ScDoc',title:'医生',width:100,align:'center'},
		{field:'ScNur',title:'护士',width:100,align:'center'},
		{field:'ScDri',title:'司机',width:100,align:'center'},
		{field:'PhvID',title:'出诊记录ID',width:100,hidden:true},
		{field:'EpisodeID',title:'就诊ID',width:100,hidden:true},
		{field:'DepartDate',title:'出诊日期',width:100,align:'center'},
		{field:'DepartTime',title:'出诊时间',width:100,align:'center'},
	    {field:'ArrDate',title:'到达日期',width:100,align:'center'},
		{field:'ArrTime',title:'到达时间',width:100,align:'center'},
		{field:'BackDate',title:'返回日期',width:100,align:'center'},
		{field:'BackTime',title:'返回时间',width:100,align:'center'},
		{field:'VisCrDate',title:'创建日期',width:100,align:'center'},
		{field:'VisCrTime',title:'创建时间',width:100,align:'center'},
		{field:'RegID',title:'登记ID',width:100,hidden:true},
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
		},
		onDblClickRow: function (rowIndex, rowData) {
			//WriteMdt(rowData.EpisodeID, rowData.CstID);
        },
        rowStyler:function(rowIndex, rowData){
			if (rowData.AuditFlag == "已审"){
				return 'background-color:pink;';
			}
		}
	};

	var param = "^^^^^^"+LgHospID; //hxy 2020-06-04
	//var uniturl = $URL+"?ClassName=web.DHCEMDisAmbMan&MethodName=JsGetDisManMasList&Params="+param;
	var uniturl = $URL+"?ClassName=web.DHCEMPreHosVis&MethodName=JsGetPreHosVisList&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 登记号
function PatNo_KeyPress_CD(e){
	
	if(e.keyCode == 13){
		var PatNo = $("#aPatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			var PatNo = GetWholePatNo(PatNo);
			$("#aPatNo").val(PatNo);
			QryDisAmbMan();  /// 查询
		}
	}
}

function PatName_KeyPress_CD(e){
	if(e.keyCode == 13){
		QryDisAmbMan();  /// 查询
	}
}




/// 登记号
function PatNo_KeyPress(e){
	
	var PatNo = $("#PatNo").val();
	if(e.keyCode == 13){
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			var PatNo = GetWholePatNo(PatNo);
			$("#PatNo").val(PatNo);
			GetPatBaseInfo(PatNo);  /// 查询
		}
	}
}

/// 查询
function QryDisAmbMan(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var RLocID = $HUI.combobox("#RLoc").getValue();        /// 登记科室
	if (typeof RLocID == "undefined") RLocID = "";
	var mMtType = $HUI.combobox("#mMtType").getValue();    /// 类型
	if (typeof mMtType == "undefined") mMtType = "";
	var aPatName = $("#aPatName").val();   /// 病人姓名
	var aPatNo = $("#aPatNo").val();       /// 登记号
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ aPatName +"^"+ mMtType +"^"+ aPatNo+"^"+LgHospID; //hxy 2020-06-04 LgHospID
	$("#bmDetList").datagrid("load",{"Params":params});
}

/// 修改
function updDisAmbMan(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		UpdOpenHosVis(rowsData.PhvID) 			/// 急诊院前出诊记录
		//GetDisAmbManInfo(rowsData.MaID);
		//newDisAmbWin();        /// 新建窗口
	}else{
		$.messager.alert("提示:","请先选中待处理行！","warning");
	}
}

/// 提取派车信息
function GetDisAmbManInfo(MaID){
	runClassMethod("web.DHCEMDisAmbMan","GetDisAmbManInfo",{"MaID":MaID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != null){
			$('.td-span-m').each(function(){
				//$(this.id).text(jsonObject[this.id]);
				$("#PatNo").val(jsonObject["EposodeID"]);
				$("#MtNotes").val(jsonObject["MtNotes"]);
				$HUI.combobox("#MtType").setValue(jsonObject["MtType"]); /// 类型
				$HUI.combobox("#DocArr").setValue(jsonObject["SCDoc"]); /// 医生
				$HUI.combobox("#NurArr").setValue(jsonObject["ScNur"]); /// 护士
				$("#DriArr").val(jsonObject["SCDri"]);//siji
				$("#MaID").text(jsonObject["MaID"])
			})
		}
	},'json',false)
}

/// 新建急救车派车窗口
function newDisAmbMan(){
	
//	var rowData = $('#bmDetList').datagrid('getSelected');
//	if (rowData == null){
//		$.messager.alert('提示',"请先选择一行记录!","error");
//		return;
//	}

	//newDisAmbWin();       /// 新建急救车派车窗口
	//InitDisAmbDefault();  /// 初始化界面默认信息
	InsOpenHosVis() 			/// 急诊院前出诊记录
	
}

/// 新建窗口
function newDisAmbWin(){
	var option = {
			buttons:[{
				text:'保存',
				iconCls:'icon-w-save',
				handler:function(){
					saveDisAmbMan();
					}
			},{
				text:'取消',
				iconCls:'icon-w-cancel',
				handler:function(){
					$('#newConWin').dialog('close');
				}
			}]
		};
	new DialogUX('急诊科救护车派车', 'newConWin', '900', '450', option).Init();

}

/// 初始化界面默认信息
function InitDisAmbDefault(){

	$(".td-span-m").text("");
	$("#PatNo").val("");
	$("#MtNotes").val("");
	
	
	$HUI.combobox("#MtType").setValue("N"); /// 类型
}

//当前病人是否存在申请记录   yyt 2019-05-25
function saveDisAmbMan(){
	if (isExistDisAmbMan()) {
		$.messager.confirm('确认对话框','该患者当天已有派车记录，是否继续添加？', function(r){
			if (r){
				 InsDisAmbMan()
			}
		});
	}else{
		 InsDisAmbMan()
	}		
}

/// 保存急诊科救护车派车数据
function InsDisAmbMan(){
	
    /// 派车记录ID
	var MaID=$('#MaID').text();
	
	/// 就诊ID
	var EpisodeID=$('#EpisodeID').text();
	
	/// 类型
	var MtType = $HUI.combobox("#MtType").getValue();
	
    /// 备注
	var MtNotes=$('#MtNotes').val();
	if(MtNotes==""){
		$.messager.alert("提示:","备注不能为空！");
		return;
	}
	
	/// 出诊记录ID
	var VisID=$('#VisID').text();	

	/// 随车医生
	var SCDoc = $HUI.combobox("#DocArr").getValue();
	
	/// 随车护士
	var SCNur = $HUI.combobox("#NurArr").getValue();
	
	/// 随车司机
	var SCDri = $("#DriArr").val();	

	///             主信息
	var mListData = EpisodeID +"^"+ LgUserID +"^"+ LgLocID +"^"+ MtType +"^"+ MtNotes +"^"+ VisID +"^"+ SCDoc +"^"+ SCNur +"^"+ SCDri;

	/// 保存
	runClassMethod("web.DHCEMDisAmbMan","Insert",{"MaID":MaID, "mListData":mListData},function(jsonString){

		if (jsonString < 0){
			$.messager.alert("提示:","保存失败，失败原因:"+jsonString,"warning");
		}else{
			$('#newConWin').dialog('close');
			$.messager.alert("提示:","保存成功！","warning");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// 取科室电话
function GetLocTelPhone(LocID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetLocTelPhone",{"LocID":LocID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}

/// 取医生电话
function GetCareProvPhone(CareProvID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetCareProvPhone",{"CareProvID":CareProvID},function(jsonString){

		if (jsonString != ""){
			TelPhone = jsonString;
		}
	},'',false)
	return TelPhone
}

///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// 病人就诊信息
function GetPatBaseInfo(PatNo){
	
	runClassMethod("web.DHCEMDisAmbMan","GetPatBaseInfo",{"PatientNo":PatNo},function(jsonString){
		var jsonObject = jsonString;
	        if(jsonObject.ErrCode<0){
			$.messager.alert('提示',""+jsonObject.ErrMsg);
			return;		
		}
		if (JSON.stringify(jsonObject) != '{}'){
			$('.td-span-m').each(function(){
				$(this).text(jsonObject[this.id]);
			})
		}else{
			$.messager.alert('错误提示',"病人信息不存在或病人非留观病人，请核实后重试！");
			return;	
		}
	},'json',false)
}

/// 删除
function delDisAmbMan(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected');   /// 选中要删除的行
	if (rowsData != null) {
		
		$.messager.confirm('确认对话框','确定要删除该项吗？', function(r){
			if (r){
				delAmbMan(rowsData.PhvID);
			}
		});
	
	}else{
		$.messager.alert("提示:","请先选中待处理行！","warning");
	}
}

/// 删除
function delAmbMan(ID){
	
	/// 保存
	runClassMethod("web.DHCEMPreHosVis","delDisAmbMan",{"ID":ID},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","删除失败，失败原因！"+jsonString,"warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("提示:","操作成功！","info");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// 当前病人是否存在申请记录   yyt 2019-05-25
function isExistDisAmbMan(){
	var isTakFlag = false;
	runClassMethod("web.DHCEMDisAmbMan","isExistDisAmbMan",{"EpisodeID":$('#EpisodeID').text()},function(jsonString){
		if (jsonString != 0){
			isTakFlag = true;
		}
	},'',false)
	return isTakFlag;
}


//打印急诊救护车派车单
function PrintDisAmbMan(){
	
    var rowsData = $("#bmDetList").datagrid('getSelected');   /// 选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示:","请先选中行操作！","warning")
		return;
	}
	
	if (rowsData.PhvID == ""){
		$.messager.alert("提示:","当前无可打印的记录！");
		return;
	}
	runClassMethod("web.DHCEMPreHosVis","PrintDisAmbMan",{"VisID":rowsData.PhvID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","打印异常！");
		}else{
			var jsonObj = jsonString;
			PrintDis_Xml(jsonObj);
		}
	},'json',false)	
}

/// 急诊救护车派车单
function PrintDis_Xml(jsonObj){
	var MyPara = "";
	///病人信息
	MyPara = "PatNo"+String.fromCharCode(2)+jsonObj.PatNo;					 		/// 登记号
	MyPara = MyPara+"^PatName"+String.fromCharCode(2)+jsonObj.PatName;		 		/// 姓名
	MyPara = MyPara+"^PatSex"+String.fromCharCode(2)+jsonObj.PatSex;		 		/// 性别
	MyPara = MyPara+"^PatAge"+String.fromCharCode(2)+jsonObj.PatAge;         		/// 年龄
	MyPara = MyPara+"^VisPlace"+String.fromCharCode(2)+jsonObj.VisPlace  			/// 出诊地点
	MyPara = MyPara+"^VisRea"+String.fromCharCode(2)+jsonObj.VisRea  
	//var TmpLabelArr = SplitString(jsonObj.VisRea, 60);  							/// 出诊事由
	//for(var n=0; n<TmpLabelArr.length; n++){
	//	if (TmpLabelArr[n] != ""){
	//		MyPara = MyPara+"^VisRea"+ (n+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[n]);
	//	}
	//}
	MyPara = MyPara+"^VisDateTime"+String.fromCharCode(2)+jsonObj.VisDate +" "+jsonObj.VisTime   		/// 接通知日期
	MyPara = MyPara+"^RecUser"+String.fromCharCode(2)+jsonObj.RecUser      			/// 接通知者
	MyPara = MyPara+"^CallerName"+String.fromCharCode(2)+jsonObj.CallerName    		/// 呼救者姓名
    MyPara = MyPara+"^CallerPhone"+String.fromCharCode(2)+jsonObj.CallerPhone  		/// 联系电话
	MyPara = MyPara+"^VisSource"+String.fromCharCode(2)+jsonObj.VisSource   		/// 信息来源 
	
	MyPara = MyPara+"^ScDoc"+String.fromCharCode(2)+jsonObj.SCDoc
	MyPara = MyPara+"^ScNur"+String.fromCharCode(2)+jsonObj.SCNur
	MyPara = MyPara+"^ScDri"+String.fromCharCode(2)+jsonObj.SCDri
	///备注
	var TmpLabelArr = SplitString(jsonObj.MtNotes, 60);
	for(var n=0; n<TmpLabelArr.length; n++){
		if (TmpLabelArr[n] != ""){
			MyPara = MyPara+"^MtNotes"+ (n+1) +String.fromCharCode(2)+txtUtil(TmpLabelArr[n]);
		}
	}
   	MyPara = MyPara+"^ArrDate"+String.fromCharCode(2)+jsonObj.ArrDate +" "+jsonObj.ArrTime   			/// 到达日期
   	
   	MyPara = MyPara+"^DepartDateTime"+String.fromCharCode(2)+jsonObj.DepartDate +" "+jsonObj.DepartTime   	/// 出诊(发车)日期
	
	MyPara = MyPara+"^BackDate"+String.fromCharCode(2)+jsonObj.BackDate +" "+jsonObj.BackTime   	/// 返回日期
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_Ambulance");
	//调用具体打印方法
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFunHDLP(myobj, MyPara, "");
}

/// 内容为 undefined 显示空
function txtUtil(txt){
	
	return (typeof txt == "undefined")?"":txt;
}

/// 急诊院前出诊记录新增
function InsOpenHosVis(){
	var link = "dhcem.prehosvis.csp";
    var iWidth="1100";                         //弹出窗口的宽度;
    var iHeight="600";                        //弹出窗口的高度;
	var iTop = (window.screen.height-30-iHeight)/2;       //获得窗口的垂直位置;
    var iLeft = (window.screen.width-10-iWidth)/2;        //获得窗口的水平位置;
	window.open(link, 'newWin', 'height='+iHeight+', width='+iWidth+', top='+iTop+', left='+iLeft+', toolbar=no, menubar=no, scrollbars=no,resizable=no, location=no, status=no');
}

/// 急诊院前出诊记录修改
function UpdOpenHosVis(PhvID){
	varPhvID=""
	var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要修改的行
	if (rowsData != null) {
	   PhvID=rowsData.PhvID;
	}
	var link = "dhcem.prehosvis.csp?PhvID="+ PhvID;
    var iWidth="1100";                         //弹出窗口的宽度;
    var iHeight="600";                        //弹出窗口的高度;
	var iTop = (window.screen.height-30-iHeight)/2;       //获得窗口的垂直位置;
    var iLeft = (window.screen.width-10-iWidth)/2;        //获得窗口的水平位置;
	window.open(link, 'newWin', 'height='+iHeight+', width='+iWidth+', top='+iTop+', left='+iLeft+', toolbar=no, menubar=no, scrollbars=no,resizable=no, location=no, status=no');
}

/// 院前登记
function OpenHosReg(){  // 

	var MaID="",EpisodeID="",PhvID=""
	var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
	   MaID=rowsData.MaID;
	   EpisodeID=rowsData.EpisodeID;
	   PhvID=rowsData.PhvID;
	   RegID=rowsData.RegID;
	}else{
		$.messager.alert("提示:","请先选中待处理行！","warning");
		return;	
	}
	
	if((rowsData.RDate=="")||(rowsData.RDate==undefined)){
		$.messager.alert("提示:","所选数据尚未派车,请先做派车处理！","warning");
		return;		
	}
	
	var link = "dhcem.prehosreg.csp?MaID="+ MaID+"&EpisodeID=" + EpisodeID+"&PhvID=" + PhvID + "&RegID=" + RegID;
    var iWidth="900";                         //弹出窗口的宽度;
    var iHeight="400";                        //弹出窗口的高度;
	var iTop = (window.screen.height-30-iHeight)/2;       //获得窗口的垂直位置;
    var iLeft = (window.screen.width-10-iWidth)/2;        //获得窗口的水平位置;
	window.open(link, 'newWin', 'height='+iHeight+', width='+iWidth+', top='+iTop+', left='+iLeft+', toolbar=no, menubar=no, scrollbars=no,resizable=no, location=no, status=no');
}


//派车
function  OpenDisAmbMan(){
	var rowsData = $("#bmDetList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {		
		newDisAmbWin();        /// 新建窗口
		InitDisAmbDefault();  /// 初始化界面默认信息
		//alert(rowsData.PhvID+"@"+rowsData.MaID)
		GetPreHosVisInfo(rowsData.PhvID)
		GetDisAmbManInfo(rowsData.MaID);

	}else{
		$.messager.alert("提示:","请先选中待处理行！","warning");
		return;
	}	
	
}
/// 急诊院前出诊记录
function GetPreHosVisInfo(VisID){
	runClassMethod("web.DHCEMPreHosVis","GetPreHosVisInfo",{"VisID":VisID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != null){
			$('#PatName').text(jsonObject.PatName);  						/// 病人姓名
			$('#PatSex').text(jsonObject.PatSex);  							/// 性别
			$('#PatAge').text(jsonObject.PatAge); 							/// 年龄
			$('#VisID').text(VisID)
		}
	},'json',false)
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
