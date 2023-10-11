//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-06-20
// 描述:	   知识库演示页面
//===========================================================================================

var editRow = -1;  /// 编辑行索引
var editid = "";   /// 编辑grid id
var checkFlag = 1; /// 区分审查还是模板保存
var PageCompObj = [    	/// 页面元素类型
	{El:"PatName", Type:"input"},
	{El:"PatSex", Type:"combobox"},
	{El:"PatBDay", Type:"datebox"},
	{El:"Height", Type:"input"},
	{El:"Weight", Type:"input"},
	//{El:"Liver", Type:"combobox"},
	{El:"Renal", Type:"combobox"},
	{El:"SpecGrps", Type:"combobox"},
	{El:"PreFlag", Type:"input"},
	{El:"itemAyg", Type:"datagrid"},
	{El:"itemDis", Type:"datagrid"},
	{El:"itemLab", Type:"datagrid"},
	{El:"labItm", Type:"datagrid"},
	{El:"itemOper", Type:"datagrid"},
	{El:"itemOrder", Type:"datagrid"},
	{El:"ProFess", Type:"combobox"},
	{El:"PatType", Type:"combobox"},	// 患者类别
	{El:"ItemSym", Type:"datagrid"}
];

var LabArray=[{"value":"Lab","text":"检验套"},{"value":"LabItm","text":"检验项"}]
var SkinArray=[{"value":"N","text":"阴性"},{"value":"Y","text":"阳性"}]
var PatTypeArr=[{"value":"门诊","text":"门诊患者"},{"value":"急诊","text":"急诊患者"},{"value":"住院","text":"住院患者"}]
var DisFlagArr = [{"value":"dis","text":"诊断"},{"value":"sym","text":"症状"}]
var PriorityArr = [{"value":"即刻医嘱","text":"即刻医嘱"},{"value":"PRN","text":"PRN"},{"value":"临时医嘱","text":"临时医嘱"},{"value":"长期医嘱","text":"长期医嘱"},{"value":"取药医嘱","text":"取药医嘱"},{"value":"出院带药","text":"出院带药"},{"value":"自备药即刻","text":"自备药即刻"},{"value":"自备药长期","text":"自备药长期"},{"value":"长期嘱托","text":"长期嘱托"},{"value":"临时嘱托","text":"临时嘱托"}]
/// 页面初始化函数
function initPageDefault(){
	
	//_openShowAuditPopProcess({"userType":"Doc"});
	//setRatio();
	
	InitPageComp(); 	  /// 初始化界面控件内容
}

function setRatio(){
    
	    var defaultRatio = 1;//默认缩放比
	    var ratio=0;
	    var screen=window.screen;
	    var ua=navigator.userAgent.toLowerCase();
	 
	    if(window.devicePixelRatio !== undefined)
	    {
	        ratio=window.devicePixelRatio;    
	    }
	    else if(~ua.indexOf('msie'))
	    {
	        if(screen.deviceXDPI && screen.logicalXDPI)
	        {
	            ratio=screen.deviceXDPI/screen.logicalXDPI;        
	        }
	    
	    }
	    else if(window.outerWidth !== undefined && window.innerWidth !== undefined)
	    {
	        ratio=window.outerWidth/window.innerWidth;
	    }
	 
	    if(ratio > 1)
	    {
	        
	        var setZoom = defaultRatio/window.devicePixelRatio; //默认zoom
	        document.body.style.zoom = setZoom.toFixed(6);
	    }
	    // return ratio;
}
	
/// 初始化界面控件内容
function InitPageComp(){
	
	/// 选择模板
	/*var option = {
		blurValidValue:true,
		hasDownArrow:true,
        onSelect:function(option){
			/// 选择模板
			LoadTempPanel(option.value, 1);
			$("#TempLabel").show();  /// 模板标题label
			$("#TempTitle").show();  /// 模板标题input
		 	var ThisTitle=option.text.split("<img")[0];
			$("#TempTitle").val(ThisTitle);
			//$HUI.combobox("#TakTemp").setValue(ThisTitle);
	    },
	    onShowPanel: function () { //数据加载完毕事件
			$("#TakTemp").combobox('reload',$URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakTemp");
        }
	};
	var url = ""; //$URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakTemp";
	new ListCombobox("TakTemp", url, '', option).init();
	*/
	$('#TakTemp').combotree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakTemp',
    	lines:true,
		animate:true,
		 onSelect:function(option){
			/// 选择模板
			LoadTempPanel(option.value, 1);
			$("#TempLabel").show();  /// 模板标题label
			$("#TempTitle").show();  /// 模板标题input
		 	var ThisTitle=option.text.split("<img")[0];
			$("#TempTitle").val(ThisTitle);
	    },
	})
	
	/// 性别
	var option = {
		blurValidValue:true,
        onSelect:function(option){
	    }
	};
	var url = $URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakDataByType&type=sex";
	new ListCombobox("PatSex", url, '', option).init();
	
	/// 肝损状态
	var option = {
		blurValidValue:true,
        onSelect:function(option){

	    }
	};
	//var url = $URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakLiver";
	//new ListCombobox("Liver", url, '', option).init();
	
	/// 肾损状态
	var option = {
		blurValidValue:true,
        onSelect:function(option){

	    }
	};
	//var url = $URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakRenal";
	//new ListCombobox("Renal", url, '', option).init();
		
	/// 特殊人群
	var option = {
		blurValidValue:true,
		multiple:true,
        onSelect:function(option){		
	    }
	};
	var url = $URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakSpecGrps";
	new ListCombobox("SpecGrps", url, '', option).init();
	
	/// 职业
	var option = {
		blurValidValue:true,
		multiple:false,
        onSelect:function(option){		
	    }
	};
	var url = $URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakDataByType&type=profess";
	new ListCombobox("ProFess", url, '', option).init();
	
	
	/// 患者类别
	var option = {
		data:PatTypeArr,
		blurValidValue:true,
		multiple:false,
        onSelect:function(option){		
	    }
	};
	var url = ""
	new ListCombobox("PatType", url, '', option).init();
}

var itemObj = {'itemAyg':0, 'itemDis':0, 'itemOrder':0, 'itemLab':0, 'itemOper':0};

/// 添加行
function add(id){
	
	endEditRow();  /// 关闭当前编辑行
	
	var WarnID = TakUniqueSign(id); /// 获取每行的唯一标识
    var rowObj = "";
    if (id == "itemLab"){
		rowObj = {Warn:WarnID, Item:'', Val:'', Uom:'', id:id};
	}else if (id == "itemOrder"){
		rowObj = {Warn:WarnID, SeqNo:'',PhDesc:'', PForm:'', DosQty:'', DosUom:'', Instr:'', Freq:'', Duration:'',  LinkSeqNo:'',id:id,OrdDate:"",FirstMark:"",OrdEndDate:""};
		//rowObj = {Warn:WarnID, PhDesc:'', PForm:'', DosQty:'', DosUom:'', Instr:'', Freq:'', Duration:'', id:id};
	}else if (id == "itemDis"){
		rowObj = {Warn:WarnID, Type:'诊断',item:"",id:id};
	}else {
		rowObj = {Warn:WarnID, Item:'', id:id};
	}
	
	
	$("#"+id).datagrid('appendRow',rowObj);

	
	if (id == "itemOrder"){		// 序号
		var index = $("#"+id).datagrid("getRowIndex",rowObj) +1;	
		// 得到columns对象
		var columns =  $("#"+id).datagrid("options").columns;
		var rows = $("#"+id).datagrid("getRows"); 
		rows[index-1][columns[0][1].field]=index+"";
		
		// 刷新该行, 只有刷新了才有效果
		$("#"+id).datagrid('refreshRow', index-1);
	}
	
}

/// 清除
function clr(id){
	$("#"+id).datagrid('loadData',{total:0,rows:[]});
}



/// 链接
function takCellUrl(value, rowData, rowIndex){

	var html = '<a href="#" onclick="del(\''+ rowData.id +'\',\''+ value +'\',\''+ rowIndex +'\')"><img src="../scripts/dhcnewpro/dhcckb/images/cancel.png" border=0/></a>';	
	return html;
}

/// 删除
function del(id, value, rowIndex){
	
	var rowsData = $("#"+id).datagrid('getRows');
	for (var index=rowsData.length-1; index >= 0; index--){
		if (rowsData[index].Warn == value){
			$("#"+id).datagrid('deleteRow',index);
		}
	}
}

/// 医嘱删除
function delord(id){
	
    var rowData = $("#"+id).datagrid('getSelected');
    var index = $("#"+id).datagrid('getRowIndex', rowData);
	$("#"+id).datagrid('deleteRow',index);

}

/// 双击行事件
function onClickRow(rowIndex, rowData) {
	
    endEditRow();  /// 关闭当前编辑行
    
    $("#"+ rowData.id).datagrid('beginEdit', rowIndex); 
    
    editid = rowData.id;   /// 当前编辑datagrid
    editRow = rowIndex;    /// 当前编辑行
}

/// 关闭当前编辑行
function endEditRow(){
	
	if ((editRow != -1)||(editRow == 0)) { 
        $("#"+editid).datagrid('endEdit', editRow); 
    }
    $("#"+ editid).datagrid("unselectRow", editRow);
    editid = "";     /// 当前编辑datagrid
    editRow = -1;    /// 当前编辑行
}

/// 保存模板
function InsTemp(){
	
	endEditRow();  /// 关闭当前编辑行
	checkFlag=0;
	var TempObj = TakTempObj();         /// 取审查对象
	if (!isIntegrity(TempObj)) return;  /// 数据完整性效验
	
	if ($("#TempTitle").val() == ""){
		$("#TempLabel").show();  /// 模板标题label
		$("#TempTitle").show();  /// 模板标题input
		$.messager.alert("提示:","请填写模板标题！","info");
		return;
	}
	
	//var ID = $HUI.combobox("#TakTemp").getValue(); /// 测试用例ID
	//获取当前combotree的tree对象
	var tree = $('#TakTemp').combotree('tree');
	//获取当前选中的节点对象
	var data = tree.tree('getSelected');
	//获取id值
	if(data==null)
	{
		var ID="";
	}else
	{
		var ID=data.value;
	}
	if (!$.isEmptyObject(TempObj)){
		var TitleTag=$("#TempTitle").val();
		var standardTag=$("#standardRadio:checked").val()=="on"?true:false;
		if(standardTag)
		{
			TitleTag=TitleTag+"[standard]";
		}
		
		InvInsTemp(ID, TitleTag , TempObj);
	}
}

/// 知识库审查对象
function TakTempObj(){

	var TempObj = {};
	TempObj.PatName = $("#PatName").val();  /// 病人姓名
	TempObj.PatSex = $HUI.combobox("#PatSex").getText();    /// 病人性别
	TempObj.PatBDay = $HUI.combobox("#PatBDay").getValue();  /// 出生日期
	TempObj.Height = $("#Height").val();    /// 身高
	TempObj.Weight = $("#Weight").val();    /// 体重
	//TempObj.Liver = $HUI.combobox("#Liver").getValue();  /// 肝损状态
	//TempObj.Renal = $HUI.combobox("#Renal").getValue();  /// 肾损状态
	TempObj.SpecGrps = $HUI.combobox("#SpecGrps").getText().split(",");  /// 特殊人群 getValue()
	TempObj.ProFess = $HUI.combobox("#ProFess").getText();  /// 职业
	TempObj.PreFlag = $("#PreFlag").val();         /// 是否怀孕
	TempObj.itemAyg = TrGridToArr("itemAyg");      /// 过敏源
	var ItemDis = TrGridToArr("itemDis");      /// 疾病诊断
	var SymArr = [];
	var DisArr = [];
	for (i=0;i<ItemDis.length;i++){
		var ItemObj=ItemDis[i];
		if (ItemObj.Type=="sym"){
			SymArr.push(ItemObj)
		}else{
			DisArr.push(ItemObj)
		}
	}
	TempObj.itemDis = DisArr;
	TempObj.ItemSym = SymArr;
	
	//TempObj.itemLab = TrGridToArr("itemLab");      /// 检验
	var ItemLab=TrGridToArr("itemLab"); 
	var LabArr=[];
	var LabItmArr=[];
	for (i=0;i<ItemLab.length;i++){
		var labObj=ItemLab[i];
		if (labObj.Type=="Lab"){
			LabArr.push(labObj)
		}if(labObj.Type=="LabItm"){
			LabItmArr.push(labObj)
		}
	}
	TempObj.itemLab = LabArr;
	TempObj.labItm=LabItmArr;	
	TempObj.itemOper = TrGridToArr("itemOper");    /// 手术
	TempObj.itemOrder = TrGridToArr("itemOrder");  /// 医嘱列表
	var SkinArr=GetSkinList();	// 将药品列表中皮试结果为阳性的药品，加入到过敏源中
	TempObj.itemAyg.push.apply(TempObj.itemAyg,SkinArr)
	TempObj.PatLoc=LgCtLocDesc	// 科室
	TempObj.DocUser=LgUserDesc	// 医生
	TempObj.Group=LgGroupDesc	// 安全组
	TempObj.Hospital=LgHospDesc	// 医院
	TempObj.Profess=LgProfessDesc	// 职称
	TempObj.ItemHisOrder = TrGridToHisOrderArr("itemOrder")	// qnp 2020/12/17 模拟历史医嘱列表
	
	TempObj.PatType = $HUI.combobox("#PatType").getValue();  /// 患者类别 qnp 2022/05/10
	return TempObj;
}

/// 调用保存模板
function InvInsTemp(ID, TempTitle, jsTempObj){

	runClassMethod("web.DHCCKBBaseDemo","InsTestCaseTemp",{"ID":ID, "TempTitle":TempTitle, "jsTempObj":JSON.stringify(jsTempObj)},function(ID){
		if (ID < 0){
			$.messager.alert("提示:","标准模板不允许修改！");
		}else{
			$.messager.alert("提示:","保存成功！","info");
			//$("#TempLabel").hide().val(""); /// 模板标题input
			//$("#TempTitle").hide();			/// 模板标题label
			$('#TakTemp').combotree('reload');
			LoadTempPanel(ID, ""); /// 加载模板
		}
	},'',false)
}

/// 提取模板数据
function LoadKbTemp(ID){
	
	var baseObject = {};
	runClassMethod("web.DHCCKBBaseDemo","JsGetKbTemp",{"ID":ID},function(jsonObject){
		baseObject = jsonObject
	},'json',false)
	return baseObject;
}

/// 选择模板
function LoadTempPanel(ID, isFlag){
	  
	ClrPanel(isFlag);  /// 清空
	var TempObj = LoadKbTemp(ID);  /// 提取模板内容
	if ($.isEmptyObject(TempObj)) {
		$.messager.alert("提示:","读取到的模板数据为空！","warning");
		return;
	}
	
	var ItemLabLen=0
	var ItemDisLen=0
	var ItmLabArr=[]
	var ItmDisArr=[]
	for(var n in PageCompObj){
		
		/// 文本框赋值
		if (PageCompObj[n].Type == "input"){
			$("#" + PageCompObj[n].El).val(TempObj[PageCompObj[n].El]);
		}
		
		/// 下拉框赋值
		if (PageCompObj[n].Type == "combobox"){
			$HUI.combobox("#" + PageCompObj[n].El).setValue(TempObj[PageCompObj[n].El]);
		}
		
		/// 时间框赋值
		if (PageCompObj[n].Type == "datebox"){
			$HUI.datebox("#" + PageCompObj[n].El).setValue(TempObj[PageCompObj[n].El]);
		}
				
		/// 列表赋值
		if (PageCompObj[n].Type == "datagrid"){
			if ((PageCompObj[n].El == "labItm")||(PageCompObj[n].El == "itemLab")) {	// 检验存了两个数组，但是界面上只有一个位置显示 qunianpeng 2020/4/4
				if(TempObj[PageCompObj[n].El]==undefined){continue;}
				ItemLabLen += TempObj[PageCompObj[n].El].length;
				ItmLabArr.push.apply(ItmLabArr,TempObj[PageCompObj[n].El])	// 数组拼接 
				
			}else if ((PageCompObj[n].El == "ItemSym")||(PageCompObj[n].El == "itemDis")) {	
				if(TempObj[PageCompObj[n].El]==undefined){continue;}
				ItemDisLen += TempObj[PageCompObj[n].El].length;
				ItmDisArr.push.apply(ItmDisArr,TempObj[PageCompObj[n].El])	// 数组拼接 
			}
			else
			{
				if(TempObj[PageCompObj[n].El]==[]) continue;
				$("#" + PageCompObj[n].El).datagrid('loadData',{total:TempObj[PageCompObj[n].El].length,rows:TempObj[PageCompObj[n].El]});
			}
		}
	}
	$("#itemDis").datagrid('loadData',{total:ItemDisLen,rows:ItmDisArr});
	$("#itemLab").datagrid('loadData',{total:ItemLabLen,rows:ItmLabArr});	
	
}
/// datagrid列表
function TrGridToArr(id){
	var nowdate = toDDMMMYYYY();
	var TmpArr = [];
	var rowsData = $("#"+id).datagrid('getRows');
	for (var m in rowsData){
		if (id == "itemOrder"){	
			//var tmpData=rowsData.concat();			// 复制数组	
			var tmpData=JSON.parse(JSON.stringify(rowsData));	// 深复制
			if(checkFlag==1){
				tmpData[m].LinkSeqNo=(tmpData[m].LinkSeqNo=="")?tmpData[m].SeqNo:tmpData[m].LinkSeqNo+"."+tmpData[m].SeqNo;
				tmpData[m].DosQty = ChangeDose(tmpData[m].DosUom, tmpData[m].DosQty);
				tmpData[m].DosUom = ChangeUnit(tmpData[m].DosUom);
				if ((tmpData[m].OrdEndDate !="")&(tmpData[m].OrdEndDate != undefined)){	// 医嘱停止日期不为空,则认为是历史医嘱
					continue;
				}
				if ((tmpData[m].OrdDate !="")&(tmpData[m].OrdDate<nowdate)){	// 医嘱日期小于当天,则认为是历史医嘱
					continue;
				}				
			}
			
			TmpArr.push(tmpData[m]);			
		}else{
			TmpArr.push(rowsData[m]);	
		}		
	}
	return TmpArr;
}

/// datagrid列表
function TrGridToHisOrderArr(id){
	var nowdate = toDDMMMYYYY();
	var TmpArr = [];
	var rowsData = $("#"+id).datagrid('getRows');
	for (var m in rowsData){
		if (id == "itemOrder"){	
			//var tmpData=rowsData.concat();			// 复制数组	
			var tmpData=JSON.parse(JSON.stringify(rowsData));	// 深复制
			if(checkFlag==1){
				tmpData[m].LinkSeqNo=(tmpData[m].LinkSeqNo=="")?tmpData[m].SeqNo:tmpData[m].LinkSeqNo+"."+tmpData[m].SeqNo;
			}
			
			if ((tmpData[m].OrdDate =="")&&((tmpData[m].OrdEndDate=="")||(tmpData[m].OrdEndDate==undefined))){	// 医嘱停止日期不为空,则认为是历史医嘱
				continue;
			}			
		
			if ((tmpData[m].OrdDate !="")&&(tmpData[m].OrdDate>=nowdate)){	// 医嘱日期小于当天,则认为是历史医嘱
				continue;
			}
			TmpArr.push(tmpData[m]);			
		}else{
			TmpArr.push(rowsData[m]);	
		}		
	}
	return TmpArr;
}


/// 知识库回调函数
function SetItemWarnFlag(itemWarnObj){
	
	var a = 11
	//alert("完成回调"+itemWarnObj.passFlag)
	
}

/// 数据完整性效验
function isIntegrity(jsTakTempObj){
	
	if (jsTakTempObj.PatName == ""){
		$.messager.alert("提示:","姓名不能为空","warning");
		return false;	
	}
	if (jsTakTempObj.PatSex == ""){
		$.messager.alert("提示:","性别不能为空","warning");
		return false;	
	}
	if (jsTakTempObj.PatBDay == ""){
		$.messager.alert("提示:","出生日期不能为空","warning");
		return false;	
	}
	if (jsTakTempObj.itemOrder.length == 0){
		$.messager.alert("提示:","药品列表不能为空","warning");
		return false;	
	}
		return true;
	
}

/// 审查
function TakCheck(){
	
	endEditRow();  /// 关闭当前编辑行
	checkFlag=1;
	var jsTakTempObj = TakTempObj();   		 /// 取审查对象
	if (!isIntegrity(jsTakTempObj)) return;  /// 数据完整性效验
	//$.messager.alert("提示:","审查通过","info",function(){
	jsTakTempObj.Action="CheckRule";;		/// 应用功能
	//var InreViewObj = new InreView({});      /// 初始化知识库
	var InreViewObj = new PDSS({});          /// 初始化知识库
	
	var PdssData={
		"lmID":"",	        //  监测日志ID
		"PatName":"张三",	//  姓名
		"SexProp":"男",		// 性别
		"AgeProp":"1993-02-10",	// 出生日期
		"Height":"170",		// 身高(厘米值)
		"Weight":"51",		// 体重(kg) 
		"BillType":"医保",	// 费别 (医保,自费)
		"BloodPress":"",	// 血压
		"SpecGrps":["肾功能不全","孕妇"],	//特殊人群
		"ProfessProp":"运动员",	// 职业
		"PatType":"门诊",	// 患者类别(门诊,住院,急诊)
		"PreFlag":"是",		// 是否怀孕
		"itemAyg":[			// 过敏记录
			{
				"Warn":"96",	// 序号
				"Item":"",
				"id":"itemAyg",	// 标识
				"item":"青霉素"	// 过敏项目
			}
		],
		"itemDis":[				// 疾病
			{
				"Warn":"14",	// 序号
				"Item":"",
				"id":"itemDis",	// 标识
				"item":"肺炎"	// 疾病
			},
			{
				"Warn":"455",
				"Item":"",
				"id":"itemDis",
				"item":"中耳炎"
			}
		],
		"itemLab":[				// 检验
			{
				"Warn":"35",	//序号
				"Item":"",		//	
				"Val":"10",		// 检验结果值
				"Unit":"mg",		// 检验结果值单位
				"id":"itemLab",	// 标识
				"item":"白细胞"	// 检验项目
			}
		],
		"itemOper":[				// 手术
			{
				"Warn":"10",		// 序号
				"Item":"",		
				"id":"itemOper",	// 标识
				"item":"颅部切合术"	// 手术名称
			}
		],
		"itemOrder":[		// 药品
			{
				"Warn":"34",				// 序号
				"PhDesc":"阿司匹林肠溶片",	// 药品名称
				"FormProp":"片剂",				// 剂型
				"OnceDose":"200",				// 单次剂量
				"Unit":"mg",				// 单次剂量单位
				"DrugPreMet":"口服",				// 用法
				"DrugFreq":"tid",				// 频次
				"Treatment":"1天",				// 疗程
				"id":"itemOrder",			// 标识
				"SeqNo":"1",				// 医嘱序号
				"LinkSeqNo":"1",			// 关联序号(1, 1.1, 1.2)
				"OrdDate":"2020-03-06",		// 医嘱日期
				"IsFirstUseProp":"首次",			// 是否首次(首次/非首次)
				"DurgSpeedProp":""			// 给药速度
			},
			{
				"Warn":"743",
				"SeqNo":"2",
				"PhDesc":"盐酸丙美卡因滴眼液",
				"FormProp":"滴眼剂",
				"OnceDose":"2",
				"Unit":"滴",
				"DrugPreMet":"滴眼",
				"DrugFreq":"每日4次",
				"Treatment":"2天",
				"LinkSeqNo":"2.2",
				"id":"itemOrder",
				"OrdDate":"2020-03-06",
				"IsFirstUseProp":"首次",
				"DurgSpeedProp":""			// 给药速度
			}	
		]
	}

	// PdssData
	//InreViewObj.refresh(PdssData, SetItemWarnFlag, 1); /// 审查
	console.log(jsTakTempObj)
	InreViewObj.refresh(jsTakTempObj, SetItemWarnFlag, 1); /// 审查
	//	}); 

}

/// 清空
function ClrPanel(hideFlag){
	
//	/// 复选框
//	$('input[type="checkbox"]').attr("checked",false);
//	
//	/// 单选
//	$('input[type="radio"]').attr("checked",false);
	
	/// 文本框
	$('input:text[id]').not('.combobox-f').not('.datebox-f').each(function(){
		$("#"+ this.id).val("");
	})

	/// Combobox
	$('input.combobox-f').each(function(){
		if ((hideFlag)&(this.id == "TakTemp")) return;
		$("#"+ this.id).combobox("setValue","");
	})
	
	/// 日期
	$('input.datebox-f').each(function(){
		$("#"+ this.id).datebox("setValue","");
	})
	
	/// 清空列表
	var itemArr = ['itemAyg', 'itemDis', 'itemOrder', 'itemLab', 'itemOper'];
	for(var i=0; i<itemArr.length; i++){
		$("#" + itemArr[i]).datagrid('loadData',{total:0,rows:[]});
	}
}

/// 审查结果指示灯
function takCellWarn(value, rowData, rowIndex){
	var html = '<div class="warn-light"><img id="WL'+ value +'" src="" border=0/></div>';	
	return html;
}

/// 获取后台唯一标识
function TakUniqueSign(id){
	
	var unIdent = "";
	runClassMethod("web.DHCCKBBaseDemo","TakUniqueIdent",{"ID":id},function(jsonString){
		unIdent = jsonString;
	},'',false)
	return unIdent;
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	
}

///调用取值函数
function fillValue(rowIndex, rowData){
	$('#itemOrder').datagrid('getRows')[editRow]['PhDesc']=rowData.CDDesc
}

/// 获取药品列表中有皮试结果为阳性的药品,加入到过敏源中
function GetSkinList(){
	
	var skinArr=[];
	var rowsData = $("#itemOrder").datagrid('getRows');
	for (var m in rowsData){
		if (rowsData[m].Skin == "Y"){		// 阳性
			if (rowsData[m].PhDesc != ""){
				var warnID = TakUniqueSign("itemAyg"); /// 获取每行的唯一标识
				var skinObj={"Warn":warnID,"Item":"","id":"itemAyg","item":rowsData[m].PhDesc}
				skinArr.push(skinObj)
			}					
		}		
	}
	
	return skinArr;
	
}
///模板管理
function DelTemp(){
	//获取当前combotree的tree对象
	var tree = $('#TakTemp').combotree('tree');
	//获取当前选中的节点对象
	var data = tree.tree('getSelected');
	//获取id值
	var TempID=data.value;
	 //var TempID = $("#TakTemp").combotree("getValue"); //$HUI.combotree("#TakTemp").getValue();
	 if(TempID == ""){
		  $.messager.alert('提示',"请先选择要删除的模板");
		  return;
		}
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBBaseDemo","DelTemp",{"ID":TempID},function(ret){
							if(ret==0){
								ClrPanel();
								$('#TakTemp').combotree('reload');
							}
				},'',false)
			}
		});
}

/// 审查【弹窗】
function OpenPdss(){
	
	 var _Width = 800;
     var _Height = 400;
	 var _Top = (window.screen.availHeight-30-_Height)/2; 
     var _Left = (window.screen.availWidth-10-_Width)/2;
	 window.open ("dhcckb.pdssservice.csp?logid=6695734", "安全用药智能审查", "height="+ _Height +", width="+ _Width +", top="+ _Top +", left="+ _Left +", toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
}

//window.onload = onload_handler;
/// 根据单位转换剂量
function ChangeDose(unit,dose){

	if (unit == ""){
		return dose;
	}
	
	///  单位中包含体重用药
	if ((unit.indexOf("/kg") !=-1 )|| (unit.indexOf("/KG") !=-1 )){
		var height =  $("#Height").val();    /// 身高
		var weight = $("#Weight").val();     /// 体重
		dose = (weight=="")?dose:dose*weight;
		return dose;
	}
	
	///  单位中包含体表面积
	if ((unit.indexOf("/m2") !=-1 )|| (unit.indexOf("/M2") !=-1 )){
		var height =  $("#Height").val();    /// 身高
		var weight = $("#Weight").val();     /// 体重
		if ((height=="")||(weight=="")) return dose;
		var area=(0.0061*height)+(0.0128*weight)-0.1529
		dose = (area=="")?dose:dose*area;
		
		return dose;
	}
	
	return dose;
}

/// 根据单位转换剂量
function ChangeUnit(unit){

	if (unit == ""){
		return unit;
	}

	if (unit.indexOf("/") !=-1){
		var unitArr = unit.split("/");
		unit  = unitArr[0];
		return unit;
	}
	
	return unit;
}

//当前日期转为yyyy-mm-dd
function toDDMMMYYYY() {  
	var nowDate = new Date();
	 var year = nowDate.getFullYear();
	 var month = nowDate.getMonth() + 1 < 10 ? "0" + (nowDate.getMonth() + 1)
	  : nowDate.getMonth() + 1;
	 var day = nowDate.getDate() < 10 ? "0" + nowDate.getDate() : nowDate
	  .getDate();
	 var dateStr = year +"-"+ month +"-"+ day;
	 return dateStr;
}

var FormatterType = function(val, row, index) {
	if(val=="sym") return "症状"
    return val;

}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
