var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

function GetWebConfig(encmeth){
	var objWebConfig=new Object();
	if (encmeth!=""){
		if (encmeth!=""){
			var TempFileds=encmeth.split(String.fromCharCode(1));
			objWebConfig.CurrentNS=TempFileds[0];
			objWebConfig.MEDDATA=TempFileds[1];
			objWebConfig.LABDATA=TempFileds[2];
			objWebConfig.Server="cn_iptcp:"+TempFileds[3]+"[1972]";
			objWebConfig.Path=TempFileds[4];
			objWebConfig.LayOutManager=TempFileds[5];
		}
	}else{
		objWebConfig=null;
	}
	return objWebConfig;
}
//导出
function ExportDataToExcel(strMethodGetServer,strMethodGetData,strFileName,strArguments)
{
	var TemplatePath = $m({                  
		ClassName:"DHCMed.Service",
		MethodName:"GetTemplatePath"
	},false);
	var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.RepList.xls";
	
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch(e) {
		$.messager.alert("提示","创建Excel应用对象失败!如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。具体操作："+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用",'info');
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","QryReportInfoToPrint","fillxlSheet",strArguments);
	var fname = xls.Application.GetSaveAsFilename(strFileName,"Excel Spreadsheets (*.xls), *.xls");
	//目录中存在重名的文件，在打开调试时选择“否”、“取消”会有报错
	//不知对选择“否”的处理如何写，暂时不处理
	try {
		xlBook.SaveAs(fname);
	}catch(e){
		//alert(e.message);
		return false;
	}
	
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);

	return true;
}
//导出报告卡详细数据 add by niepeng 2013-12-18
function ExportDataToExcelNP(strMethodGetServer,strMethodGetData,strFileName,strArguments)
{
	var TemplatePath = $m({                  
		ClassName:"DHCMed.Service",
		MethodName:"GetTemplatePath"
	},false);
	var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.ReportListNP.xls";
	
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch(e) {
			$.messager.alert("提示","创建Excel应用对象失败!如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。具体操作："+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用",'info');
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg = tkMakeServerCall("DHCMed.DTHService.ReportInterface","QryReportInfoToPrintNP","fillxlSheet",strArguments);
	var fname = xls.Application.GetSaveAsFilename(strFileName,"Excel Spreadsheets (*.xls), *.xls");
	//目录中存在重名的文件，在打开调试时选择“否”、“取消”会有报错
	//不知对选择“否”的处理如何写，暂时不处理
	try {
		xlBook.SaveAs(fname);
	}catch(e){
		//alert(e.message);
		return false;
	}
	
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);
	return true;
}

function b64toBlob(data){
    var sliceSize = 512;
    var chars = atob(data);
    var byteArrays = [];
    for(var offset=0; offset<chars.length; offset+=sliceSize){
        var slice = chars.slice(offset, offset+sliceSize);
        var byteNumbers = new Array(slice.length);
        for(var i=0; i<slice.length; i++){
            byteNumbers[i] = slice.charCodeAt(i);
        }
        var byteArray = new Uint8Array(byteNumbers);
        byteArrays.push(byteArray);
    }
    return new Blob(byteArrays, {
        type: ''
    });
}


function toHtml(newArr){
    var data = ['<table border="1" rull="all" style="border-collapse:collapse">'];
  	//标题
	data.push('<tr><td colspan="11" style="height:40pt;text-align:center;font-size:24px;font-weight:bold;">死亡病例网络直报日登记</td></tr>');
    var trStyle = 'height:32px';
    var tdStyle0 = 'vertical-align:middle;text-align:center;padding:0 4px;';
    data.push('<tr style="'+trStyle+'">');
    //表头
    data.push('<th style="width:200px">网号</th>');
    data.push('<th style="width:180px">报告状态</th>');
    data.push('<th style="width:180px">死者姓名</th>');
    data.push('<th style="width:100px">性别</th>');
    data.push('<th style="width:100px">年龄</th>');
    data.push('<th style="width:200px">职业</th>');
    data.push('<th style="width:400px;">根本死因</th>');
    data.push('<th style="width:400px;">户口地址</th>');
    data.push('<th style="width:100px">死亡日期</th>');
    data.push('<th style="width:100px">填卡日期</th>');
    data.push('<th style="width:150px">填报科室</th>');
    //输出查询结果
    for(var i=0; i<newArr.length; i++){	    
        data.push('<tr style="'+trStyle+'">');
        for(var j=0; j<newArr[i].length; j++){
			var value = newArr[i][j];
            data.push(
                '<td style="'+tdStyle0+'">'+value+'</td>'
            );
        }
        data.push('</tr>');
    }
    data.push('</table>');
	
    return data.join('');
}

//导出
function ExportToExcel(){	
	//查询界面
    var strDTHList =$m({
		ClassName:"DHCMed.DTHService.ReportSrv",
		QueryName:"QryReportInfo",	
		ResultSetType:'array',	
		aSttDate: $('#txtStartDate').datebox('getValue'), 
		aEndDate: $('#txtEndDate').datebox('getValue'), 
		aRepLoc: $('#cboRepLoc').combobox('getValue'), 
		aHospital:$('#cboSSHosp').combobox('getValue'),   
		aRepStatus: $('#cboRepStatus').combobox('getValue'),
		aPatName: $('#txtPatName').val(),
		aMrNo: $('#txtMrNo').val(),	
		aRegNo: $('#txtRegNo').val()
	}, false);
	var DTHArray = JSON.parse(strDTHList);
	var DTHlen = DTHArray.length;
	if (DTHlen<1) return;
    //选定特定列到新数组，字段顺序与表头一致
	var newArr = [];
	for (var ind=0; ind<DTHlen;ind++) {
		var r = [];
		r.push(DTHArray[ind]["DeathNo"],DTHArray[ind]["RepStatusDesc"],DTHArray[ind]["PatName"],DTHArray[ind]["Sex"],DTHArray[ind]["Age"],DTHArray[ind]["Occupation"],DTHArray[ind]["BaseReason"],DTHArray[ind]["CurrAddress"],DTHArray[ind]["DeathDate"],DTHArray[ind]["RepDate"],DTHArray[ind]["RepLoc"])        
		newArr.push(r);
    }
    		    
    var table = toHtml(newArr);
    var uri = 'data:application/vnd.ms-excel;base64,'
    , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>'
    , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
    , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }

    var ctx = { worksheet: 'Worksheet', table: table };
    var data = base64(format(template, ctx));

    if (window.navigator.msSaveBlob){
        var blob = b64toBlob(data);
        window.navigator.msSaveBlob(blob, '死亡报告登记.xls');
    } else {
        var alink = $('<a style="display:none"></a>').appendTo('body');
        alink[0].href = uri + data;
        alink[0].download = '死亡报告登记.xls';
        alink[0].click();
        alink.remove();
    }

}
   
//明细
function toDtlHtml(newArr){
    var data = ['<table border="1" rull="all" style="border-collapse:collapse">'];
  	//标题
    var trStyle = 'height:32px';
    var tdStyle0 = 'vertical-align:middle;text-align:center;padding:0 4px;';
    data.push('<tr style="'+trStyle+'">');
    //表头
   	data.push('<th>报告卡ID</th>');
	data.push('<th>报告地区编码</th>');
	data.push('<th>报告卡编号</th>');
	data.push('<th>人群分类编码</th>');
	data.push('<th>人群分类</th>');
	data.push('<th>死者姓名</th>');
	data.push('<th>性别编码</th>');
	data.push('<th>性别</th>');
	data.push('<th>身份证号码</th>');
	data.push('<th>出生日期</th>');
	data.push('<th>年龄</th>');
	data.push('<th>民族编码</th>');
	data.push('<th>民族</th>');
	data.push('<th>婚姻状况编码</th>');
	data.push('<th>婚姻状况</th>');
	data.push('<th>主要职业及工种编码</th>');
	data.push('<th>主要职业及工种</th>');
	data.push('<th>文化程度编码</th>');
	data.push('<th>文化程度</th>');
	data.push('<th>生前常住地址类型</th>');
	data.push('<th>生前详细地址</th>');
	data.push('<th>常住地址地区编码</th>');
	data.push('<th>户籍地址类型</th>');
	data.push('<th>户籍地址</th>');
	data.push('<th>户籍地址编码</th>');
	data.push('<th>生前工作单位</th>');
	data.push('<th>死亡时间</th>');
	data.push('<th>死亡地点编码</th>');
	data.push('<th>死亡地点</th>');
	data.push('<th>家属姓名</th>');
	data.push('<th>家属联系电话</th>');
	data.push('<th>家属住址或工作单位</th>');
	data.push('<th>a直接导致死亡的疾病</th>');
	data.push('<th>a直接导致死亡的疾病ICD10编码</th>');
	data.push('<th>a发病到死亡的时间间隔</th>');
	data.push('<th>a发病到死亡的时间间隔单位</th>');
	data.push('<th>b直接导致死亡的疾病</th>');
	data.push('<th>b直接导致死亡的疾病ICD10编码</th>');
	data.push('<th>b发病到死亡的时间间隔</th>');
	data.push('<th>b发病到死亡的时间间隔单位</th>');
	data.push('<th>c直接导致死亡的疾病</th>');
	data.push('<th>c直接导致死亡的疾病ICD10编码</th>');
	data.push('<th>c发病到死亡的时间间隔</th>');
	data.push('<th>c发病到死亡的时间间隔单位</th>');
	data.push('<th>d直接导致死亡的疾病</th>');
	data.push('<th>d直接导致死亡的疾病ICD10编码</th>');
	data.push('<th>d发病到死亡的时间间隔</th>');
	data.push('<th>d发病到死亡的时间间隔单位</th>');
	data.push('<th>其它疾病诊断</th>');
	data.push('<th>其它疾病诊断ICD10编码</th>');
	data.push('<th>根本死亡原因</th>');
	data.push('<th>根本死因ICD编码</th>');
	data.push('<th>最高诊断单位编码</th>');
	data.push('<th>最高诊断单位</th>');
	data.push('<th>最高诊断依据编码</th>');
	data.push('<th>最高诊断依据</th>');
	data.push('<th>上报医生</th>');
	data.push('<th>住院号</th>');
	data.push('<th>医生上报日期</th>');
	data.push('<th>填报单位编码</th>');
	data.push('<th>填报单位名称</th>');
	data.push('<th>单位类型编码</th>');
	data.push('<th>单位类型名称</th>');
	data.push('<th>备注</th>');
	data.push('<th>死者生前病史及症状体征</th>');
	data.push('<th>被调查者姓名</th>');
	data.push('<th>与死者关系</th>');
	data.push('<th>联系地址或工作单位</th>');
	data.push('<th>被调查者电话号码</th>');
	data.push('<th>死因推断</th>');
	data.push('<th>调查者签名</th>');
	data.push('<th>调查日期</th>');
	data.push('<th>删除时间</th>');
	data.push('<th>录入时间</th>');
	data.push('<th>录入人ID</th>');
	data.push('<th>审核标志</th>');
	data.push('<th>审核时间</th>');
	data.push('<th>卡片状态编码</th>');
	data.push('<th>卡片状态</th>');
	data.push('<th>卡片来源</th>');
   
    //输出查询结果
    for(var i=0; i<newArr.length; i++){	    
        data.push('<tr style="'+trStyle+'">');
		$.each(newArr[i],function(key,value) {
			if ((value)&&(!isNaN(value))) { //判断字符串是否为纯数字
				 tdStyle0 = tdStyle0 +';mso-number-format:\@';  //解决纯数字列导出没有0或变成科学style="mso-number-format:'\@';"   
			}
            data.push(
                '<td style="'+tdStyle0+'">'+value+'</td>'
            );
        });
        data.push('</tr>');
    }
    data.push('</table>');
	
    return data.join('');
}

//导出明细
function ExportDtlToExcel(){	
	//查询界面
    var strDTHList =$m({
		ClassName:"DHCMed.DTHService.ReportInterface",
		QueryName:"QryReportInfo",	
		ResultSetType:'array',	
		aSttDate: $('#txtStartDate').datebox('getValue'), 
		aEndDate: $('#txtEndDate').datebox('getValue'), 
		aRepLoc: $('#cboRepLoc').combobox('getValue'), 
		aHospital:$('#cboSSHosp').combobox('getValue'),   
		aRepStatus: $('#cboRepStatus').combobox('getValue'),
		aPatName: $('#txtPatName').val(),
		aMrNo: $('#txtMrNo').val(),	
		aRegNo: $('#txtRegNo').val()
	}, false);
	var DTHArray = JSON.parse(strDTHList);
	var DTHlen = DTHArray.length;
	if (DTHlen<1) return;
			    
    var table = toDtlHtml(DTHArray);
    var uri = 'data:application/vnd.ms-excel;base64,'
    , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>'
    , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
    , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }

    var ctx = { worksheet: 'Worksheet', table: table };
    var data = base64(format(template, ctx));

    if (window.navigator.msSaveBlob){
        var blob = b64toBlob(data);
        window.navigator.msSaveBlob(blob, '死亡报告明细表.xls');
    } else {
        var alink = $('<a style="display:none"></a>').appendTo('body');
        alink[0].href = uri + data;
        alink[0].download = '死亡报告明细表.xls';
        alink[0].click();
        alink.remove();
    }
    
}


function fillxlSheet(xlSheet,cData,cRow,cCol)
{
	var cells = xlSheet.Cells;
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			cells(cRow+i,cCol+j).Value = arryDataY[j];
			//cells(cRow+i,cCol+j).Borders.Weight = 1;
		}
	}
	return cells;
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

//画单元格
function AddCells(objSheet,fRow,fCol,tRow,tCol,xTop,xLeft)
{
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(2).LineStyle=1;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

//单元格合并
function MergCells(objSheet,fRow,fCol,tRow,tCol)
{
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).MergeCells =1;
}

//单元格对其
//-4130 左对齐
//-4131 右对齐
//-4108 居中对齐
function HorizontCells(objSheet,fRow,fCol,tRow,tCol,HorizontNum)
{
   objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).HorizontalAlignment=HorizontNum;
}
