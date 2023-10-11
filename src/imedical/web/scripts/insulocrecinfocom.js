
///******************************************************************
///功能说明：
///          数据导入
///******************************************************************
//科室导入
function InLocImpt()
{		
	importDiag();		
}

function importDiag()
{
	try{
		
	   //var fd = new ActiveXObject("MSComDlg.CommonDialog");
      // fd.Filter = "*.xls"; //过滤文件类别
      //fd.FilterIndex = 2;
      //fd.MaxFileSize = 128;
	 //fd.ShowSave();//如果是需要打开的话，就要用fd.ShowOpen();
    //fd.ShowOpen();
    //filePath=fd.filename;//fd.filename是用户的选择路径
   var filePath="";
	filePath=FileOpenWindow();
	
	$.messager.progress({
				title: "提示",
				msg: '正在导入科室数据',
				text: '导入中....'
			}
			);
			
			
			
   if(filePath=="")
    {
	   $.messager.alert('提示','请选择文件！','info')
	    return ;
     }
   
   
    
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
			var UpdateStr=buildImportStr(xlsheet,i);
			var savecode=tkMakeServerCall("web.DHCINSULocInfoCtl","Save",UpdateStr)
			if(savecode==null || savecode==undefined) savecode=-1
			if(eval(savecode)>=0){
				sucRowNums=sucRowNums+1;
				
		
			}else{
				errRowNums=errRowNums+1; 
				if(ErrMsg==""){
					ErrMsg=i;
				}else{
					ErrMsg=ErrMsg+"\t"+i;
				}
			}
		}
		
		if(ErrMsg==""){
			setTimeout('$.messager.progress("close");', 1 * 1000);
			$.messager.alert('提示','数据正确导入完成','info');
		}else{
			setTimeout('$.messager.progress("close");', 1 * 1000);
			var tmpErrMsg="成功导入【"+sucRowNums+"/"+(rows-1)+"】条数据";
			tmpErrMsg=tmpErrMsg+"失败数据行号如下：\n\n"+ErrMsg;
			$.messager.alert('报错提示',tmpErrMsg,'error');   
		}
	}
	catch(e){
		$.messager.alert('报错提示',"导入时发生异常0：ErrInfo："+e.message,'info');  
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
	
	//Rowid^科室代码^科室名称^科室类型^标准科室代码^专业科室代码^科室Dr^审批床位数^实际床位数^科室成立时间^医师数据^技师数量^药师数量^护师数量^科室负责人^科室负责人电话^病区护士长^病区护士长电话^是否重点科室^重点科室等级^科室是否发生费用^医院机构编码^开始日期^开始时间^结束日期^结束时间^有效标识^经办人Dr^经办日期^经办时间^备注^扩展01^扩展02^扩展03^扩展04^扩展05
	
	//1-5 Rowid^科室代码^科室名称^科室类型^标准科室代码^
	var updateStr="";
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,1).value);                     //分类
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,2).value);       
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,3).value);       
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,4).value);       
	//6-10 专业科室代码^科室Dr^审批床位数^实际床位数^科室成立时间^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,5).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,6).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,7).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,8).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,9).value);		//

	//11-15 医师数据^技师数量^药师数量^护师数量^科室负责人^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,10).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,11).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,12).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,13).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,14).value);		//

	//16-20 科室负责人电话^病区护士长^病区护士长电话^是否重点科室^重点科室等级^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,15).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,16).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,17).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,18).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,19).value);		//

	//21-25 科室是否发生费用^医院机构编码^开始日期^开始时间^结束日期^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,20).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,21).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,22).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,23).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,24).value);		//

	//26-30 结束时间^有效标识^经办人Dr^经办日期^经办时间^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,25).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,26).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,27).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,28).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,29).value);		//

	//31-36 备注^扩展01^扩展02^扩展03^扩展04^扩展05
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,30).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,31).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,32).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,33).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,34).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,35).value);		//
	
	return updateStr;
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





//科室导出
function InLocEpot()
{
	try
	{
				
	var rtn = $cm({
	dataType:'text',
	ResultSetType:"Excel",
	ExcelName:"科室信息维护", //默认DHCCExcel
	ClassName:"web.DHCINSULocInfoCtl",
	QueryName:"QryInLocInfo",
	InRowid:"",
	KeyWords:$('#KeyWords').val(),
	HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
     },false);
     location.href = rtn;
	$.messager.progress({
				title: "提示",
				msg: '正在导出科室数据',
				text: '导出中....'
			});
	setTimeout('$.messager.progress("close");', 3 * 1000);	
		
		return;
	} catch(e) {
		$.messager.alert("警告",e.message);
		$.messager.progress('close');
	};
	
	
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
	
	return FilePath;
}

$(".FileWindow").on("change","input[type='file']",function(){
	
	var filePath=$(this).val();
	
});