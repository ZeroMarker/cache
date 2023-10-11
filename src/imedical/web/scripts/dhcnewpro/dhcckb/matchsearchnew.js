/**
*	Author: 		Qunianpeng
*	Create: 		2019/05/15
*	Description:	药品信息导入及查询
*/
var mDel1 = String.fromCharCode(1);  /// 分隔符
var mDel2 = String.fromCharCode(2);  /// 分隔符
var pid="";
/// 页面初始化函数
function initPageDefault(){
	InitCombobox();
	InitPatEpisodeID();		/// 初始化加载病人就诊ID
	InitButton();			/// 初始化按钮绑定事件
	InitDrugListGrid();		/// 初始化药品列表
	
}
//shy 2020-12-3
function InitCombobox()
{
		var cbox = $HUI.combobox("#searchitem",{
		valueField:'id', textField:'text', multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:true,
		data:[
			{id:'43',text:'商品名(西药)'},  
			{id:'74532',text:'带剂型通用名(西药)'},
			{id:'81818',text:'带剂型通用名(中成药)'},
			{id:'44',text:'厂家(西药)'},
			{id:'81835',text:'厂家(中成药)'},
			{id:'78015',text:'批准文号(西药)'},         //shy 2021/6/17
			{id:'81832',text:'批准文号(中成药)'},       //shy 2021/6/17
			{id:'77980',text:'规格'},
			{id:'40',text:'剂型'},
			{id:'114554',text:'中药饮片匹配'},
			{id:'74531',text:'等效单位(等效数量)'}      //shy 2021/6/20
		],
		formatter:function(row){  
			var rhtml;
			if(row.selected==true){
				rhtml = row.text+"<span id='i"+row.id+"' class='icon icon-ok'></span>";
			}else{
				rhtml = row.text+"<span id='i"+row.id+"' class='icon'></span>";
			}
			return rhtml;
		},
		onChange:function(newval,oldval){
			$(this).combobox("panel").find('.icon').removeClass('icon-ok');
			for (var i=0;i<newval.length;i++){
				$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
			}
		}
	});
	var cbox = $HUI.combobox("#searchitem2",{
		valueField:'id', textField:'text', multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:true,
		data:[
			{id:'43',text:'商品名(西药)'},  
			{id:'74532',text:'带剂型通用名(西药)'},
			{id:'81818',text:'带剂型通用名(中成药)'},
			{id:'44',text:'厂家(西药)'},
			{id:'81835',text:'厂家(中成药)'},
			{id:'78015',text:'批准文号(西药)'},         //shy 2021/6/17
			{id:'81832',text:'批准文号(中成药)'},       //shy 2021/6/17
			{id:'77980',text:'规格'},
			{id:'40',text:'剂型'},
			{id:'114554',text:'处方应付(中药饮片)'},
			{id:'74531',text:'等效单位(等效数量)'}      //shy 2021/6/20
		],
		formatter:function(row){  
			var rhtml;
			if(row.selected==true){
				rhtml = row.text+"<span id='i"+row.id+"' class='icon icon-ok'></span>";
			}else{
				rhtml = row.text+"<span id='i"+row.id+"' class='icon'></span>";
			}
			return rhtml;
		},
		onChange:function(newval,oldval){
			$(this).combobox("panel").find('.icon').removeClass('icon-ok');
			for (var i=0;i<newval.length;i++){
				$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
			}
		}
	});
	var cbox = $HUI.combobox("#showitem",{
		valueField:'id', textField:'text', multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:true,
		data:[
			{id:'74532',text:'带剂型通用名(西药)'},
			{id:'81818',text:'带剂型通用名(中成药)'},
			{id:'114554',text:'处方应付(中药饮片)'},
			{id:'44',text:'厂家(西药)'},
			{id:'81835',text:'厂家(中成药)'},
			{id:'77980',text:'规格'},
			{id:'40',text:'剂型'},
			{id:'74531',text:'等效单位(等效数量)'},
			{id:'78012',text:'包装'},
			{id:'78015',text:'批准文号'}
		],
		formatter:function(row){  
			var rhtml;
			if(row.selected==true){
				rhtml = row.text+"<span id='i"+row.id+"' class='icon icon-ok'></span>";
			}else{
				rhtml = row.text+"<span id='i"+row.id+"' class='icon'></span>";
			}
			return rhtml;
		},
		onChange:function(newval,oldval){
			$(this).combobox("panel").find('.icon').removeClass('icon-ok');
			for (var i=0;i<newval.length;i++){
				$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
			}
		}
	});
	
	
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");
	EpisodeID = getParam("EpisodeID");	
}

/// 初始化按钮绑定事件
function InitButton(){

	/// 计算
	//$('#calc').on("click",CalcClick); 

	/// 编码，商品名回车	
	//$('#queryCode,#queryDesc').bind('keypress',InputPrese);
	$('#queryDesc').bind('keypress',InputPrese);
	
	

}

/// 初始化药品列表
function InitDrugListGrid(){

	var  columns=[[    
	       	{field:'num',title:'序号',width:40}, 
	       	{field:'drugCode',title:'药品代码',width:100},     
	        {field:'drugName',title:'药品名称',width:180},
	        {field:'drugDataType',title:'药品字典',width:100},
	        {field:'libDrugCode',title:'知识库药品代码',width:180},  
	        {field:'libDrugName',title:'知识库药品名称',width:180}, 
	        {field:'libDrugDataType',title:'知识库药品字典',width:100}, 
	        {field:'generName',title:'带剂型通用名',width:120},
	        /* {field:'proName',title:'商品名',width:200}, */
	        {field:'factory',title:'厂家',width:240},
	        {field:'matchFlag',title:'标注',width:120}
	    ]]
	
	///  定义datagrid
	var option = {		
		toolbar:'#toolbar',
		border:false,
	    rownumbers:true,
	    //fitColumns:true,
	    singleSelect:true,
	    pagination:true,
	    pageSize:20,
	    pageList:[20,40,100],
		//showHeader:false,
		//fitColumn:true,
		rownumbers : false,
		singleSelect : true,
	    fit:true,	
	    checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
			window.open("dhcckb.editprop.csp?parref="+rowData.dicDrugID);
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
	    
	    //showSuccessMount(LgUserID);
          
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBMatchSearch&MethodName=QueryDrugList&params="+"^^^"+LgUserID;
	new ListComponent('druglist', columns, uniturl, option).Init();
}
function showSuccessMount(LgUserID)
{

	var resultData="";
	
	runClassMethod("web.DHCCKBMatchSearch","GetSuccessData", {"LgUserID":LgUserID}, function (ret) {
       resultData =ret;
       if(resultData!="")
		{
			var allCount=resultData.split("^")[0];
			var successCount=resultData.split("^")[1];
			var successCountPv=resultData.split("^")[2];
			$.messager.alert("提示","匹配总数:"+allCount+",匹配数量:"+successCount+",匹配率:"+successCountPv+"%");	
		}
    }, "text", true);	
	
	
}

/// 查询
function Query(){
	
	var code = "" //$("#queryCode").val().trim();
	var desc = $("#queryDesc").val().trim();
	var params = code +"^"+ desc +"^"+ pid+"^"+LgUserID;

	$("#druglist").datagrid("load",{"params":params});

}


/// 代码，描述回车事件
function InputPrese(e){

	 if(e.keyCode == 13){
		Query();
	}
}

/// 导入数据
function UploadData(searchModel){
	
	var wb;//读取完成的数据
	var rABS = false; //是否将文件读取为二进制字符串
    //var files = $("#articleImageFile")[0].files;
    var files = $("#filepath").filebox("files");
    if (files.length == 0){
		$.messager.alert("提示:","请选择文件后，重试！","warning");
		return;   
	}
	
	$.messager.progress({ title:'请稍后', msg:'数据正在导入中...' });
	pid=serverCall("web.DHCCKBMatchSearch","MatchDataPid");  
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
			   	MatchSearch(searchModel);
				//$("#druglist").datagrid("reload");   /// 刷新页面数据	  sunhuiyong  注释  2021-4-21
				
		//shy 2021-3-15	
		var Search=$HUI.combobox("#searchitem").getValues();   
		var selectitem=""
		for(var i=0;i<Search.length;i++)
		{
			if(selectitem=="")
			{
				selectitem=Search[i];
			}else
			{
				selectitem=selectitem+"^"+Search[i];
			}
		}
		var Show=$HUI.combobox("#showitem").getValues();   
		var showitem=""
		for(var i=0;i<Show.length;i++)
		{
			if(showitem=="")
			{
				showitem=Show[i];
			}else
			{
				showitem=showitem+"^"+Show[i];
			}
		}
		runClassMethod("web.DHCCKBMatchSearch","getCKBColumn",
		{
			showitem:showitem,
			selectitem:selectitem
		},function(ret){
			var columns=[];
			for(var i=0;i<ret.length;i++){
				if(ret[i].field=="num"){
					columns.push({field: "num", title: ret[i].title,width:40})
				}else if(ret[i].field=="drugCode"){
					columns.push({field: "drugCode", title: ret[i].title,width:100})
				}else if(ret[i].field=="drugName"){
					columns.push({field: "drugName", title: ret[i].title,width:180})
				}else if(ret[i].field=="libDrugCode"){
					columns.push({field: "libDrugCode", title: ret[i].title,width:100})
				}else if(ret[i].field=="libDrugName"){
					columns.push({field: "libDrugName", title: ret[i].title,width:180})
				}else if(ret[i].field=="DrugForm"){
					columns.push({field: "DrugForm", title: ret[i].title,width:100})
				}else if(ret[i].field=="itmSpecificationype"){
					columns.push({field: "itmSpecificationype", title: ret[i].title,width:100})
				}
				else{
					columns.push(ret[i])	
				}
			}
				$('#druglist').datagrid({
					fit:true,
					columns:[columns]
				})
				$("#druglist").datagrid("reload");   /// 刷新页面数据		
				$.messager.progress('close');
		})
			}else{
				var TmpArr = [];
				for(var m = n; m < obj.length; m++) {
					/* var mListDataArr = []; var mListTitleArr = [];
					for(x in obj[m])  {
					   if (m == 0){
					   	  mListTitleArr.push(x);
					   }
					   mListDataArr.push(obj[m][x]||"");
					}
					if (m == 0){
				   	   TmpArr.push(mDel1 + mListTitleArr.join("[next]"));
				    }
					TmpArr.push(mDel1 + mListDataArr.join("[next]")); */
					var mListData = mDel1 + obj[m].itmCode +"[next]"+ obj[m].itmDrugCode +"[next]"
									+ ChangeValue(obj[m].itmDrugName) +"[next]"+  (ChangeValue(obj[m].itmGeneric)||"") +"[next]"
									+ChangeValue(obj[m].itmManf) +"[next]"+ChangeValue(obj[m].itmSpecificationype)+"[next]"+ChangeValue(obj[m].itmDrugForm)
									+"[next]"+ChangeValue(obj[m].itmDrugDataType)+"[next]"+ChangeValue(obj[m].itmApprovalNum)+"[next]"+ChangeValue(obj[m].itmEquivalent)
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
		Ins(0);	//从第一行开始读		
  
   }
   fileReader.readAsArrayBuffer(files[0]);
   //Query();
   //Query();
  
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

/// 临时存储数据
function InsTmpGlobal(mListData, Fn, m){

	var ErrFlag = 0;
	runClassMethod("web.DHCCKBMatchSearch","MatchTmpData",{"pid":pid,"mListData":mListData,"LgUserID":LgUserID},function(val){
		Fn(m);
	})

	return ErrFlag;
}

/// 匹配检索
function MatchSearch(searchModel){
	var Search=$HUI.combobox("#searchitem").getValues();   //shy 2020-12-4 添加匹配项
	var Searchstr=""
	for(var i=0;i<Search.length;i++)
	{
		if(Searchstr=="")
		{
			Searchstr=Search[i];
		}else
		{
			Searchstr=Searchstr+"^"+Search[i];
		}
	}
	var Search2=$HUI.combobox("#searchitem2").getValues();   //shy 2020-12-4 添加匹配项
	var Searchstr2=""
	for(var i=0;i<Search2.length;i++)
	{
		if(Searchstr2=="")
		{
			Searchstr2=Search2[i];
		}else
		{
			Searchstr2=Searchstr2+"^"+Search2[i];
		}
	}
	//searchModel = 1; // qnp 2021/1/13 临时恢复成之前的匹配算法
	//runClassMethod("web.DHCCKBMatchSearch","MatchSearch", {"pid":pid,"searchModel":searchModel}, function (ret) {
	if(searchModel=="0")
	{
		runClassMethod("web.DHCCKBMatchSearch","MatchSearchByDataListJobNew", {"pid":pid,"searchModel":Searchstr,"searchModelTwice":Searchstr2,"lgUserID":LgUserID}, function (ret) {
        //retvalArr = ret.replace(/(^\s*)|(\s*$)/g, "").split("@@");
        Query();
    }, "text", true);
	}else
	{
	runClassMethod("web.DHCCKBMatchSearch","MatchSearchByDataListDic", {"pid":pid,"searchModel":Searchstr,"lgUserID":LgUserID}, function (ret) {
        //retvalArr = ret.replace(/(^\s*)|(\s*$)/g, "").split("@@");
        Query();
    }, "text", true);		
	}
}

/// 导出
function ExportMatchData(){
	
	runClassMethod("web.DHCCKBMatchSearch","ExportMatchData", {"pid":pid,"LgUserID":LgUserID}, function (ret) {
        retvalArr = ret.replace(/(^\s*)|(\s*$)/g, "").split("@@");
    }, "text", false);
    if (retvalArr == "") {
        $.messager.alert("提示:", "取数据错误！","info");
        return;
    }
    
    var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择路径后,重试！</font>","error");
		return;
	}
	
    //1、获取XLS导出路径
    var path = tkMakeServerCall("web.DHCDocConfig", "GetPath");
    var Template = path + "DHCCKB_ExportMatchData.xls";

    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var objSheet = xlBook.ActiveSheet;
    
    
    //var adrRepDrgItmArr=adrRepDrgItmList.split("||");
	for(var k=0;k<retvalArr.length;k++){
		var itmArr=retvalArr[k].split("[next]");
		objSheet.Cells(k+1,1).value=itmArr[0]; //序号
		objSheet.Cells(k+1,2).value=itmArr[1]; //药品code
		objSheet.Cells(k+1,3).value=itmArr[2]; //药品名称
		//objSheet.Cells(k+1,4).value=itmArr[3]; //字典类型
		objSheet.Cells(k+1,4).value=itmArr[3]; //通用名
		objSheet.Cells(k+1,5).value=itmArr[4]; //生成企业
		objSheet.Cells(k+1,6).value=(((itmArr[5]=="")||(itmArr[5]==undefined))?itmArr[5]:itmArr[5].toString()); //标注
	}  

    xlBook.SaveAs(filePath + formatDate(0)+"药品匹配数据" + ".xls");
    //xlApp=null;
    xlBook.Close(savechanges=false);
    xlApp.Visible = false; 
    objSheet = null;
    $.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
}


/// 导出
function ExportMatchDataNew(){
	
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:formatDate(0)+"药品匹配数据", //默认DHCCExcel
		ClassName:"web.DHCCKBMatchSearch",
		QueryName:"ExportMatchDataNew",
		pid:pid,
		LgUserID:LgUserID
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
}



function ChangeValue(val){

	if (val === undefined){
		val = ""
	}
	return val;
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })

/// 匹配检索 LoginInfo ClientIPAdd
function ContrastMatchData(){

	runClassMethod("web.DHCCKBMatchSearch","ContrastMatchData", {"loginInfo":LoginInfo,"clientIP":ClientIPAdd,"LgUserID":LgUserID}, function (ret) {
       if(ret=="0"){
	     $.messager.alert("提示","对照完成！");
		}else{
		 $.messager.alert("提示","对照失败！");
		}
    }, "text", true);
}
// 匹配率显示窗口
function showWin()
{
	var  columns=[[    
	       	{field:'matchItem',title:'匹配项',align:'center',width:240}, 
	       	{field:'marchAll',title:'总数',align:'center',width:110},
	       	{field:'onMatch',title:'匹配数',align:'center',width:110},     
	        {field:'matchLv',title:'匹配率',align:'center',width:100}
	        
	    ]]
	
	///  定义datagrid
	var option = {		
		border:false,
	    rownumbers:true,
	    singleSelect:true,
		rownumbers : false,
		singleSelect : true,
	    fit:true,	
	    checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
			
        },
	    onLoadSuccess: function (data) { 
	    
          
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBMatchSearch&MethodName=GetSuccessData&lgUserID="+LgUserID;
	new ListComponent('LvList', columns, uniturl, option).Init();
	
	$HUI.dialog("#PPLv").open();
	
}