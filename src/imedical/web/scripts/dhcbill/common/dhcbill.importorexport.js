// dhcbill/common/dhcbill.importorexport.js
document.write("<script language = javascript src = 'https://cdn.polyfill.io/v2/polyfill.min.js'></script>");
document.write("<script language = javascript src = '../insuqc/js/lib/xlsx.core.min.js'></script>");
//<script type="text/javascript" src="../insuqc/js/lib/xlsx.core.min.js"></script>
//https://cdn.polyfill.io/v2/polyfill.min.js

/// 功能说明：导入数据共通js处理
/// 入参说明：GlobalDataFlg --> 临时数据标志 1 保存到临时global表中 0 保存到表中(需要传入类名和方法名)
///                 ClassName      --> 处理类名
///                 MethodName  --> 方法名
///                 ExtStr              --> 备用参数(医院编码^医保类型)
/// 修改履历：董科锋 2019 05 07 新做成
function ExcelImport(GlobalDataFlg, ClassName, MethodName, ExtStrPam,RtnFun){
	_OpenAndGetExcelDataArr().then(function(dataArr){   //获取excel数据
		_ImportRowsData(ClassName,MethodName,GlobalDataFlg, ExtStrPam, dataArr, 2, "", "", 0, 0, 2, RtnFun)
	})
}

/// 功能说明：导入进度提醒框创建
function loadLableInit(){
	//导入进度提醒框创建
	if($('#loadLable').length==0){
		$loadLable=$("<div id='loadLable' class='loadLablestyle'>正在导入</div>");
		$("body").append($loadLable);
	};
}

function SetValue(value)
{
	if(value == undefined)
	{
		value="";
	}
	
	value=value.toString().replace(/\"/g, "");
	value=value.toString().replace(/\?/g,"");
	return value;
}

//打开文件夹，选择文件的共通处理
function FileOpenWindow(){
	if($('#FileWindowDiv').length==0){
		$('#FileWindowDiv').empty();
		
		$FileWindowDiv=$("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
		$("body").append($FileWindowDiv);
		$FileWindow=$("<input id='FileWindow' type='file' name='upload'/>");
		$("#FileWindowDiv").append($FileWindow);
	}
	$('#FileWindow').val("");
	$('#FileWindow').select();
	$(".FileWindow input").click();
	var FilePath=$('#FileWindow').val();
	//alert(FilePath);
	return FilePath;
}

$(".FileWindow").on("change","input[type='file']",function(){
	//alert(3233);
	var filePath=$(this).val();
	alert("filePath="+filePath);
});

///打开文件并获取excel数据
function _OpenAndGetExcelDataArr(){  //获取excel数据
	//var _this=this 
	//_this.InitProgress();  //初始化导出提示框
	return new Promise(function(resolve, reject) {
		$('#FileWindowDiv').empty();
		$FileWindowDiv=$("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
		$("table").append($FileWindowDiv);
		$FileWindow=$("<input id='FileWindow' type='file' name='upload'/>");
		$("#FileWindowDiv").append($FileWindow);
		//$('#FileWindow1').val("");
 		//实现消息框的阻塞执行		
 		$('#FileWindow').select();
		if (!!window.ActiveXObject || "ActiveXObject" in window){  //ie支持click
			   	_InitProgress("数据导入初始化...");  //创建提示框  //ie 在click前创建 否则可能渲染不出来
				$('#loadLable').show();
				$('#FileWindow').click();  
				_GetExcelData().then(function(data){	
					resolve(data) 
				})

   		}else {   //谷歌浏览器需要添加到onchange 事件	
   			$('#FileWindow').click();  
   			$("#FileWindow").change(function(){
    			_InitProgress("数据导入初始化...");  //创建提示框  在click后创建 否则取消选择后关闭不了
				$('#loadLable').show();
    			_GetExcelData().then(function(data){
   				resolve(data) 
   				})
   			})	
   		} 		
   	}) 	
}
//创建导入导出提示框 
function _InitProgress(InitMsg){
    if ((InitMsg=="")||(InitMsg=="undefined")) {InitMsg="正在导入中..."}
   	if($('#loadLable').length!=0){
		$('#loadLable').html(InitMsg)  //初始化下
	}
	if($('#loadLable').length==0){
		$loadLable=$("<div id='loadLable' style='display:none;position:fixed;border-style: solid;border-width:1px;border-color:#46A3FF;background-color:#FFFFDF;width:400px;height:60px; z-index:10000;top:-200px;left:-100px;right:0px;bottom:0px;margin:auto;text-align:center;padding:20px;'>"+InitMsg+"</div>");
		$("body").append($loadLable);
	};
}
///获取excel数据
function _GetExcelData(){
	return  new Promise(function(resolve, reject) {	
		$('#loadLable').html("数据读取中，请稍等.....")  //初始化下
		var FilePath=$('#FileWindow').val();
		//$.messager.alert("提示",FilePath)	
		if(!FilePath){
			$('#loadLable').hide()
			return;
		}
		var suffix=FilePath.substring(FilePath.lastIndexOf(".")+1,FilePath.length);
		if((suffix!="xls")&&(suffix!="xlsx")){
			$.messager.alert("提示","文件类型不正确");
			$('#loadLable').hide()
			return 
		}
		var files = $('#FileWindow')[0].files;	        
		var fileReader = new FileReader();  //重新 readAsBinaryString 	 	
   	 	fileReader.readAsArrayBuffer(files[0]);// 以数组形式
   		//fileReader.readAsBinaryString(files[0]);// 以二进制方式打开文件  //ie不支持
   		var fixdata=function(data) { //文件流转BinaryString  //匿名方法   解决 xls 读取进异常的问题 bug
               var o = "",w = 10240;
               for(var l = 0; l < data.byteLength / w; ++l) {
               	o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
               }
               o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
               return o;
           }

   		fileReader.onload = function(ev) {
   			try {	               
   				var data = ev.target.result;
         		var workbook = XLSX.read(btoa(fixdata(data)), { type: 'base64'}),  // binary	base64
         		persons=[];
         	} catch (e) {
	         	$('#loadLable').hide();
         		return $.messager.alert('文件类型不正确!');
         	}
			// 遍历每张表读取
			for (var sheet in workbook.Sheets) {
				if (workbook.Sheets.hasOwnProperty(sheet)) {
					worksheet = workbook.Sheets[sheet]['!ref'];
					persons = persons.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet], {header:1,defval:""}));  //转成数组和空字符处理
       				break ;  //只取第一张表
				}
			}
       		resolve(persons) 
		}
	})
}
/// 功能说明：二维数据的数据循环导入系统中
/// 入参说明：ClassName     --> 保存行数据的类
///           MethodName    --> 保存行数据的方法
///           GlobalDataFlg --> 保存到临时global中的标志 1 临时global数据 0 非临时global数据(此时类和方法名称必须传入)
///           ExtStrPam     --> 扩展参数
///           Rows          --> 二维数据数据
///           RecIndex      --> 数组的第几行数据(序号从1开始)
///           ErrMsg        --> 错误消息
///           GlobalDataKey --> 导入数据记录错误的globalkey
///           SumNum        --> 成功行数
///           ErrNum        --> 失败行数
///           StartRow      --> 从哪一行开始导入(不传则从第二行开始导入)
function _ImportRowsData(ClassName, MethodName, GlobalDataFlg, ExtStrPam, Rows, RecIndex, ErrMsg, GlobalDataKey, SumNum, ErrNum, StartRow, RtnFun){
	
	var RowNums=Rows.length;      //数组总数目
	if ((RowNums<1)||(RecIndex>RowNums)) {
		$('#loadLable').hide();
		return 0;
	}
	
	var RowIndex=RecIndex-1;      //数组序号 比行数据的序号少一个
	var RowData=Rows[RowIndex];   //行数据(一维数组)
	var ColNums=RowData.length;   //列数目
	
	var ImportNums=RowNums-(StartRow-1)   //有效导入行数
	var ImportIndex=RecIndex-(StartRow-1) //导入数据序号
	var BaseImportInfo="本次导入的数据共计"+ImportNums+"行"+ColNums+"列.";
	
	/// 组织行数据格式 为 上箭头分割的数据字符串
	var RowDataInfo="";
	var ColVal="";
	for (var colIndex=0; colIndex<ColNums; colIndex++){
		ColVal=RowData[colIndex];   //列数据
		if(colIndex==0){
			RowDataInfo=ColVal;
		}else{
			RowDataInfo=RowDataInfo+"^"+ColVal;
		}
	}
	
	/*
	if(RowDataInfo==""){
		$('#loadLable').hide();
		return 0;
	}
	*/
	
	//alert("RowDataInfo="+RowDataInfo);
	
	var RowImportMsg=BaseImportInfo+"<br/>"+"第"+ImportIndex+"行导入开始..."
	$('#loadLable').html(RowImportMsg)
	
	$cm({
		ClassName:"BILL.EINV.BL.COM.ImportOrExportCtl"
		,MethodName:"ExcelImportAjaxN"
		,ImportClass:ClassName
		,ImportMethod:MethodName
		,RowIndex:RecIndex
		,RowDataInfo:RowDataInfo
		,UserDr:session['LOGON.USERID']
		,GlobalDataFlg:GlobalDataFlg
		,ExtStr:ExtStrPam
		,GlobalDataKey:GlobalDataKey
	},function(data){
		var ResultDesc="";
		if(data.Status=="-100"){                //发生不能继续往下走的错误时,停止循环
			$('#loadLable').hide();
			$.messager.alert("温馨提醒",data.ErrMsg+"第"+ImportIndex+"行"+RowDataInfo);
			return 0;
		}

		if(data.Status>0){
			var GlobalDataKey=data.GlobalDataKey;       //数据key
			SumNum=SumNum+1;    //成功数量+1
			ResultDesc="成功";
		}else if (data.Status != "EMPTY"){
			ErrNum=ErrNum+1     //失败数量+1
			if(ErrMsg==""){
				ErrMsg=data.ErrMsg;
			}else{
				ErrMsg=ErrMsg+"\n"+data.ErrMsg;
			}
			ResultDesc="失败";
		}else{
			ResultDesc="空数据";
		}
		
		RowImportMsg=BaseImportInfo+"<br/>"+"第"+ImportIndex+"行导入完成["+ResultDesc+"].";
		$('#loadLable').html(RowImportMsg)
		
		//判断是否为最后一行数据
		if(RecIndex==RowNums){
			$('#loadLable').hide();
			var empty = ImportNums - SumNum - ErrNum;
			var ResultMsgInfo=BaseImportInfo+"成功"+SumNum+"行,失败"+ErrNum+"行,空数据"+empty+"行.";
			$.messager.alert('提示',ResultMsgInfo);

			//有回调函数的时候,调用回调函数，入参为返回值
			if(typeof(RtnFun)!='undefined'){
				RtnFun();
			}
		}else{
			RecIndex=RecIndex+1   //不是最后一行数据的时候递归调用导入数据
			_ImportRowsData(ClassName, MethodName, GlobalDataFlg, ExtStrPam, Rows, RecIndex, ErrMsg, GlobalDataKey, SumNum, ErrNum, StartRow, RtnFun);  //导入下一行数据
		}
			
	},"json");
	
	
}