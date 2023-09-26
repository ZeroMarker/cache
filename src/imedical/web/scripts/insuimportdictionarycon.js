/**
 * 导入对照字典公共JS
 * FileName:insuimportdictionarycon.js
 * xubaobao 2019-04-04
 * 版本：V1.0
 * hisui版本:0.1.0
 */

//var DicCode="DLL";             //医保接口类型 

///******************************************************************
///功能说明：
///          医师数据导入
///******************************************************************
function importData(KeyCode,InsuType,HospitalNo)
{
	//alert(KeyCode+"^"+InsuType+"^"+HospitalNo)
	try{
		/*var fd = new ActiveXObject("MSComDlg.CommonDialog");
		fd.Filter = "*.xls"; //过滤文件类别
		fd.FilterIndex = 2;
		fd.MaxFileSize = 128;
		fd.ShowOpen();
		filePath=fd.filename;//fd.filename是用户的选择路径*/
		
		var filePath="";
		filePath=FileOpenWindow();
		if(filePath=="")
		{
			//$.messager.alert('提示','请选择文件！');
			$.messager.alert("简单提示", "请选择文件", 'info');
			return ;
		}
		
		$.messager.progress({
			title: "提示",
			msg: '正在导入字典数据',
			text: '导入中....'
		});
		
		var ErrMsg="";     //错误数据
		var errRowNums=0;  //错误行数
		var sucRowNums=0;  //导入成功的行数
    
		xlApp = new ActiveXObject("Excel.Application"); 
		xlBook = xlApp.Workbooks.open(filePath); 
		xlBook.worksheets(1).select(); 
		var xlsheet = xlBook.ActiveSheet;
		var rows=xlsheet.usedrange.rows.count;
		var columns=xlsheet.usedRange.columns.count;
		try{
			for(i=2;i<=rows;i++){
				var pym="";
				var Instring=buildImportStr(xlsheet,i);
				//var KeyCode=DicCode;
				//var InsuType=""
				//var HospitalNo=""
				var userDr=LgUserID;                        //用户Dr
				var ConInfo=Instring+"^"+userDr+"^"+HospitalNo    //增加医院编号
				
				$.post(
					APP_PATH+"/INSUDictionaryContrast/SaveDicConAjax",
					{
						KeyCode:KeyCode
						,InsuType:InsuType
						,HospitalNo:HospitalNo
						,ConInfo:ConInfo
					},
					function(data,textStatus){
						if(textStatus=="success"){
							if(data.status>0){
								sucRowNums=sucRowNums+1;
								//reloadHisDicConGV('reload');
							}else{
								errRowNums=errRowNums+1; 
								if(ErrMsg==""){
									ErrMsg=i;
								}else{
									ErrMsg=ErrMsg+"\t"+i;
								}
								//$.messager.alert('温馨提醒','对照信息保存失败：'+info);
							}
					}else{
						$.messager.alert('系统错误','系统异常，请稍后重试');
					}
				},
				'json');
			}
		
			if(ErrMsg==""){
				setTimeout('$.messager.progress("close");', 2 * 1000);
				$.messager.alert('提示','数据正确导入完成');
				
			}else{
				var tmpErrMsg="成功导入【"+sucRowNums+"/"+(rows-1)+"】条数据";
				tmpErrMsg=tmpErrMsg+"失败数据行号如下：\n\n"+ErrMsg;
				$.messager.alert('提示',tmpErrMsg);   
			}       
		}	
		catch(e){
			$.messager.alert('提示',"导入时发生异常0：ErrInfo："+e.message);  
		}
		finally{
			xlBook.Close (savechanges=false);
			xlApp.Quit();
			xlApp=null;
			xlsheet=null;
		}
	}	
	catch(e){
		$.messager.alert('提示',"导入时发生异常1："+e.message);
	}
	finally{
		setTimeout('$.messager.progress("close");', 1 * 1000);
	} 
}

function buildImportStr(xlsheet,rowindex){
	var tmpVal="";
	//HIS编码^HIS描述^医保编码^医保名称
	Instring=SetValue(xlsheet.Cells(rowindex,1).value);                     //分类
	Instring=Instring+"^"+SetValue(xlsheet.Cells(rowindex,2).value);       
	Instring=Instring+"^"+SetValue(xlsheet.Cells(rowindex,3).value);       
	Instring=Instring+"^"+SetValue(xlsheet.Cells(rowindex,4).value); 
	return Instring;
}

function SetValue(value)
{
	if(value == undefined){
		value="" ;
	}
	value=value.toString().replace(/\"/g, "");
	value=value.toString().replace(/\?/g,"");
	return value;
}


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
	//alert("filePath="+filePath);
});
