///insu.imporexpport.js
var xlApp=null;
var xlBook=null;
var xlsheet=null;

function DestoryExcelObject(){
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
}
/// 功能说明：导入数据共通js处理
/// 入参说明：GlobalDataFlg --> 临时数据标志 1 保存到临时global表中 0 保存到表中(需要传入类名和方法名)
///                 UserDr           --> 操作员
///                 ClassName        --> 处理类名
///                 MethodName       --> 方法名
///                 ExtStr           --> 备用参数(医院编码^医保类型)
///                 RtnFunction      --> 导入完成后的回调的js方法
/// 修改履历：董科锋 2019 05 07 新做成
///           董科锋 2020 03 11 导入完成后增加回调函数
function ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam, RtnFunction){
	//打开导入的Excel数据
	try {
		filePath=FileOpenWindow();
	} catch (e) { 
		alert(e.message) ;
		return false;
	}
	if(filePath==""){ return false;}
	
	loadLableInit();                //初始化提醒框
	$('#loadLable').show();

	var ErrMsg="";     //数据check的错误
	var errRowNums=0;  //错误行数
	var sucRowNums=0;  //导入成功的行数
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.open(filePath); 
	xlBook.worksheets(1).select(); 
	xlsheet = xlBook.ActiveSheet;
	var rows=xlsheet.usedrange.rows.count;
	var columns=xlsheet.usedRange.columns.count;
	try{
		ExcelImportDo(GlobalDataFlg, UserDr, ClassName, MethodName, xlsheet, 2, rows, columns, sucRowNums, errRowNums, ExtStrPam, RtnFunction);
	}
	catch(e){
		alert("导入时发生异常：ErrInfo："+e.message) ;
		$('#loadLable').hide();
		DestoryExcelObject();
	}
	/*
	finally{
		$('#loadLable').hide();
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}*/
}

function ExcelImportDo(GlobalDataFlg, UserDr, ClassName, MethodName, xlsheet, rowIndex, allrows, allcols, sucnums, errnums, ExtStrPam, RtnFunction){
	var rtnRowIndex=0;
	var nextRowIndex=0;
	var ImportResultInfo="";
	var InfoRowIndex=rowIndex-1;     ///数据是第几行
	var tmpRows=allrows-1;
	var BaseInfo="本次导入的数据共计"+tmpRows+"行"+allcols+"列。";
	var tmpInfo=""
	
	var RowDataStr="";
	var tmpFieldInfo="";
	for(i=1; i<=allcols; i++){
		tmpFieldInfo=SetValue(xlsheet.Cells(rowIndex, i).text);
		if(i==1){
			RowDataStr=tmpFieldInfo;
		}else{
			RowDataStr=RowDataStr+"^"+tmpFieldInfo;
		}
	}
	
	tmpInfo=BaseInfo+"<br/>当前正在导入第"+InfoRowIndex+"/"+tmpRows+"条数据。";
	$('#loadLable').html(tmpInfo);
	$('#loadLable').show();
	
	//导入数据
	/*
	var Url=APP_PATH+"/com.ImportOrExportCtl/ExcelImportAjax";
	$.post(
		Url
		,{
			ClassName:ClassName
			,MethodName:MethodName
			,RowIndex:rowIndex
			,RowDataInfo:RowDataStr
			,UserDr:UserDr
			,GlobalDataFlg:GlobalDataFlg
			,ExtStr:ExtStrPam
		}
		,function(data,textStatus){
			$('#loadLable').hide();    //执行完成后台代码后，关闭显示框
			if(textStatus=="success"){
				if(data.status>=0){
					if(data.status==0){
						errnums=errnums+1;    //失败数目
					}else{
						sucnums=sucnums+1;    //成功数目
					}
					//导入成功的时候，判断是否有下一条需要导入的数据
					rtnRowIndex=parseInt(data.rowIndex);
					if(rtnRowIndex>=allrows){    //已经是最后一条的场合
						DestoryExcelObject();
						ImportResultInfo=BaseInfo+"\n,成功导入"+sucnums+"条,失败"+errnums+"条";
						alert(ImportResultInfo);
					}else{    //不是最后一条的场合
						nextRowIndex=rtnRowIndex+1;    //下一行数据
						ExcelImportDo(GlobalDataFlg, UserDr, ClassName, MethodName, xlsheet, nextRowIndex, allrows, allcols, sucnums, errnums, ExtStrPam);    //导入下一行数据
					}
				}else{
					$.messager.alert('导入失败',data.info);
				}
			}else{
				$.messager.alert('系统错误','系统异常，请稍后重试');
			}
		},
		'json'
	);
	*/
	$cm({
		ClassName:"web.InsuImpOrExpCtl"
		,MethodName:"ExcelImportAjax"
		,ImportClass:ClassName
		,ImportMethod:MethodName
		,RowIndex:rowIndex
		,RowDataInfo:RowDataStr
		,UserDr:UserDr
		,GlobalDataFlg:GlobalDataFlg
		,ExtStr:ExtStrPam
	},function(data){
		$('#loadLable').hide();    //执行完成后台代码后，关闭显示框
		if(data.status>=0){
			if(data.status==0){
				errnums=errnums+1;    //失败数目
			}else{
				sucnums=sucnums+1;    //成功数目
			}
			//导入成功的时候，判断是否有下一条需要导入的数据
			rtnRowIndex=parseInt(data.rowIndex);
			if(rtnRowIndex>=allrows){    //已经是最后一条的场合
				DestoryExcelObject();
				ImportResultInfo=BaseInfo+"\n,成功导入"+sucnums+"条,失败"+errnums+"条";
				alert(ImportResultInfo);
				//+dongkf 2020 03 11 start
				if(typeof(RtnFunction)=="function"){
					RtnFunction();   //回调方法
				}
				//+dongkf 2020 03 11 end
			}else{    //不是最后一条的场合
				nextRowIndex=rtnRowIndex+1;    //下一行数据
				ExcelImportDo(GlobalDataFlg, UserDr, ClassName, MethodName, xlsheet, nextRowIndex, allrows, allcols, sucnums, errnums, ExtStrPam, RtnFunction);    //导入下一行数据
			}
		}else{
			$.messager.alert('导入失败',data.info);
		}
	});
	
}

/// 功能说明：导入进度提醒框创建
function loadLableInit(){
	//导入进度提醒框创建
	if($('#loadLable').length==0){
		$loadLable=$("<div id='loadLable' style='display:none;position:absolute;border-style: solid;border-width:1px;border-color:#46A3FF;background-color:#FFFFDF;width:400px;height:60px;z-index:20;left:350px;top:200px;text-align:center;padding:20px;'>正在导入</div>");
		$("body").append($loadLable);
	};
}

function SetValue(value)
{
	if(value == undefined)
	{
		value="" ;
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