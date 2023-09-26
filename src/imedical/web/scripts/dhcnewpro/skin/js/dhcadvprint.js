//congyue
//2017-12-12
alert("OK");
function printTumble(printTumble){
	alert(printTumble);
	var ID = printTumble;
	var retval=tkMakeServerCall("web.DHCADVCOMMONPRINT","GetPrintData",ID);
	if(retval==""){
		$.messager.alert("提示:","取数据错误！");
		return;
	}
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_Tumble.xlsx";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	objSheet.Cells(2,2).value=retvalArr[44]+" "+retvalArr[45]; //报告日期
	objSheet.Cells(2,7).value=retvalArr[1]; //编码

	objSheet.Cells(4,7).value=retvalArr[23]; //企业联系电话
	objSheet.Cells(5,2).value=retvalArr[5]; //登记号
	objSheet.Cells(5,7).value=retvalArr[24]; //型号规格
	objSheet.Cells(6,2).value=retvalArr[4]; //患者姓名
	objSheet.Cells(6,4).value=retvalArr[2]; //性别
	objSheet.Cells(6,7).value=retvalArr[25]; //产品编号
	objSheet.Cells(7,7).value=retvalArr[26]; //产品批号
	objSheet.Cells(8,1).value=retvalArr[6]; //预期治疗疾病或作用
	objSheet.Cells(8,7).value=retvalArr[27]+retvalArr[28]; //操作人
	objSheet.Cells(9,2).value=retvalArr[7]+" "+retvalArr[8]; //诊疗时间
	objSheet.Cells(9,7).value=retvalArr[29]; //有效期至
	objSheet.Cells(10,7).value=retvalArr[30]; //生产日期
	objSheet.Cells(11,2).value=retvalArr[9]; //事件主要表现
	objSheet.Cells(11,7).value=retvalArr[31]; //停用日期
	objSheet.Cells(12,2).value=retvalArr[10];  //事件发生日期
	objSheet.Cells(12,7).value=retvalArr[32]; //植入日期
	objSheet.Cells(13,2).value=retvalArr[11]; //事件发现日期
	objSheet.Cells(13,7).value=retvalArr[25]; //产品编号
	objSheet.Cells(14,2).value=retvalArr[12]+retvalArr[13]; //实际使用场所
	objSheet.Cells(14,6).value=retvalArr[33];  //事件发生初步原因分
	objSheet.Cells(15,2).value=retvalArr[14]+" "+retvalArr[15]+" "+retvalArr[16]; //死亡时间事件的结果
	objSheet.Cells(17,1).value=retvalArr[17]; //事件陈述
	objSheet.Cells(17,6).value=retvalArr[34]; //事件初步处理情况
	objSheet.Cells(19,7).value=retvalArr[35]; //事件报告状态
	objSheet.Cells(22,6).value=retvalArr[36]; //省级监测技术机构评价意见
	objSheet.Cells(26,6).value=retvalArr[37]; //国家监测技术机构评价意见
	objSheet.Cells(29,9).value=retvalArr[48]; //事件之间是否具有合理的先后顺序
	objSheet.Cells(31,2).value=retvalArr[18]; //产品名称
	objSheet.Cells(31,9).value=retvalArr[49]; //事件是否属于所使用医疗器械可能导致的伤害类型
	objSheet.Cells(32,2).value=retvalArr[19]; //商品名称
	objSheet.Cells(33,2).value=retvalArr[20]; //注册证号
	objSheet.Cells(33,9).value=retvalArr[50]; //事件是否可以用合并用药的作用、患者病情或其他非医疗器械因素来解释
	objSheet.Cells(34,2).value=retvalArr[21]; //生产企业名称
	objSheet.Cells(35,2).value=retvalArr[22]; //生产企业地址
	objSheet.Cells(36,8).value=retvalArr[51]; //关联性评价结果

	objSheet.Cells(37,2).value=retvalArr[38]; //报告人职称
	objSheet.Cells(37,4).value=retvalArr[39]; //报告人
	objSheet.Cells(37,7).value=retvalArr[41]; //报告科室
	objSheet.Cells(38,2).value=retvalArr[42]; //报告人联系电话
	objSheet.Cells(38,7).value=retvalArr[43]; //邮箱	
	xlBook.SaveAs(filePath+retvalArr[1]+".xls");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
	
}

