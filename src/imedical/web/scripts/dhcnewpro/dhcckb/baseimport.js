//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-05-15
// 描述:	   知识库基础数据导入
//===========================================================================================

var pid = 1;
var mDel1 = String.fromCharCode(1);  /// 分隔符
var mDel2 = String.fromCharCode(2);  /// 分隔符
/// 页面初始化函数
function initPageDefault(){

	/// 初始化加载病人列表
	InitPatList();
	
	/// 初始化病人基本信息
	InitPagePanel();
}

/// 初始化病人基本信息
function InitPagePanel(){


}

/// 临时存储数据
function InsTmpGlobal(mListData, Fn, m){

	var ErrFlag = 0;
	runClassMethod("web.DHCCKBBaseImport","InsTmpGlobal",{"pid":pid, "mListData":mListData},function(val){
		Fn(m);
	})

	return ErrFlag;
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	
	///  定义columns
	var columns=[[
		{field:'itmIndex',title:'序号',width:40,align:'center',hidden:true},
		{field:'itmCode',title:'代码',width:100},
		{field:'itmGeneric',title:'通用名',width:100,styler: function(value, rowData, index){
//	        if (rowData.itmErrMsg != ""){
//				return 'background-color:pink;';
//			}
		}},
		{field:'itmEnglish',title:'英文名',width:100},
		{field:'itmGoodName',title:'商品名称',width:100},
		{field:'itmIngr',title:'成份',width:100},
		{field:'itmInd',title:'适应症',width:300},
		{field:'itmUsage',title:'用法用量',width:100},
		{field:'itmEffects',title:'不良反应',width:300},
		{field:'itmTaboo',title:'禁忌',width:100},
		{field:'itmAttent',title:'注意事项',width:400},
		{field:'itmInter',title:'药物相互作用',width:300},
		{field:'itmToxi',title:'毒理研究',width:100},
		{field:'itmAppNum',title:'批准文号',width:100},
		{field:'itmManf',title:'生产企业',width:100},
		{field:'itmClass',title:'药物分类',width:100},
		{field:'itmErrMsg',title:'错误信息',width:300}
	]];

	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
		},
        rowStyler:function(rowIndex, rowData){
	        if (rowData.itmErrMsg != ""){
				return 'background-color:pink;';
			}
		}
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCCKBBaseImport&MethodName=QryDataWaitToImp&pid="+pid;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 导入数据
function InsTmp(){
	
	var wb;//读取完成的数据
	var rABS = false; //是否将文件读取为二进制字符串
    //var files = $("#articleImageFile")[0].files;
    var files = $("#articleImageFile").filebox("files");
    if (files.length == 0){
		$.messager.alert("提示:","请选择文件后，重试！","warning");
		return;   
	}

	$.messager.progress({ title:'请稍后', msg:'数据正在导入中...' });
	var binary = "";
    var fileReader = new FileReader();
    fileReader.onload = function(ev) {
        try {
            //var data = ev.target.result;
			var bytes = new Uint8Array(ev.target.result);
			var length = bytes.byteLength;
			for(var i = 0; i < length; i++) {
				binary += String.fromCharCode(bytes[i]);
			}
			if(rABS) {
				wb = XLSX.read(btoa(fixdata(binary)), {//手动转化
					type: 'base64'
				});
			} else {
				wb = XLSX.read(binary, {
					type: 'binary'
				});
			}
                //persons = []; // 存储获取到的数据
        } catch (e) {
			$.messager.alert("提示:","文件类型不正确！","warning");
			$.messager.progress('close');
			return;
        }

		var obj = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
		if(!obj||obj==""){
			$.messager.alert("提示:","读取文件内容为空！","warning");
			$.messager.progress('close'); 
			return;
		}
		
		var Ins = function(n){
			if (n >= obj.length){
				$("#bmDetList").datagrid("reload");   /// 刷新页面数据
				$.messager.progress('close');
				InsTmpDic();
			}else{
				var TmpArr = [];
				for(var m = n; m < obj.length; m++) {
					var mListData = mDel1 + obj[m].itmCode +"^"+ ChangeValue(obj[m].itmGeneric) +"^"+ (obj[m].itmEnglish||"") +"^"+ (ChangeValue(obj[m].itmGoodName)||"") +"^"+ (obj[m].itmIngr||"") +"^"+ (obj[m].itmInd||"") +"^"+ (obj[m].itmUsage||"");
					   mListData = mListData +"^"+ (obj[m].itmEffects||"") +"^"+ (obj[m].itmTaboo||"") +"^"+ (obj[m].itmAttent||"") +"^"+ (obj[m].itmInter||"") +"^"+ (obj[m].itmToxi||"") +"^"+ (obj[m].itmAppNum||"") +"^"+ (obj[m].itmManf||"") +"^"+ (obj[m].itmClass||"");
					TmpArr.push(mDel1 + mListData);
					if ((m != 0)&(m%100 == 0)){
						/// 临时存储数据
						InsTmpGlobal(TmpArr.join(mDel2), Ins, m+1);
						TmpArr.length=0;
						break;
					}
				}
				if (TmpArr.join(mDel2) != ""){
					/// 临时存储数据
					InsTmpGlobal(TmpArr.join(mDel2), Ins, m);
				}
			}
		}
		Ins(0);
   }
   fileReader.readAsArrayBuffer(files[0]);
}

//文件流转BinaryString
function fixdata(data) { 
	var o = "",
		l = 0,
		w = 10240;
	for (; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
	o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
	return o;
}

/// 情况数据
function clrPanel(){
	
	$.messager.confirm('确认对话框',"确定要清空临时数据吗？", function(r){
		if (r){
			killTmpGlobal(); /// 删除临时global
			$("#bmDetList").datagrid("reload");   /// 刷新页面数据
		}
	})
}

/// 查询
function Query(){
	
	var itemCode = $("#itemCode").val();    			/// 代码
	var itemDesc = $("#itemDesc").val();    			/// 名称
	var params = itemCode +"^"+ itemDesc;
	$("#bmDetList").datagrid("load",{"Params":params}); /// 刷新页面数据
}

/// 导入存储数据
function InsTmpDic(){

	runClassMethod("web.DHCCKBBaseImport","InsTmpDic",{"pid":pid},function(obj){
		if (obj != null){
			$.messager.alert("提示:","导入完成！成功记录数："+ obj.SuccessNum +"条；失败记录数："+ obj.ErrorNum +"条","warning");
			$("#bmDetList").datagrid("reload");   /// 刷新页面数据
			return;
		}
	},'json',false)
}

/// 校验成功
function checkData(){
	
	$.messager.alert("提示:","校验成功！暂无任何操作","warning");
	$("#bmDetList").datagrid("reload");   /// 刷新页面数据
}

/// 删除临时global
function killTmpGlobal(){

	runClassMethod("web.DHCCKBBaseImport","killTmpGlobal",{"pid":pid},function(jsonString){},'',false)
}


function ChangeValue(val){

	if (val === undefined){
		val = ""
	}
	return val;
}

/// 页面关闭之前调用
function onbeforeunload_handler() {
    //killTmpGlobal();  /// 清除临时global
}

window.onbeforeunload = onbeforeunload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })