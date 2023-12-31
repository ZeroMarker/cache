
var Doclen=0, Apolen=0, DAlen=0, Displen=0, DADilen=0, Nuslen=0, DADiNulen=0,DADiNuPalen=0;
var DocList="", ApoList="",DispList="",NurList="",PatList="";
// 导出Excel
function ExportExcel(ID,TypeCode,filePath)
{
	if(ID==""){
		$.messager.alert("提示:","报表ID为空！");
		return;
	}
	if(TypeCode=="material"){
		var retval=tkMakeServerCall("web.DHCADVMEDREPORT","getMataRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1、获取XLS导出路径
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MataReport.xls";
	
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
	if(TypeCode=="drugerr"){
		var retval=tkMakeServerCall("web.DHCADVMEDSAREPORT","getMedsRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1、获取XLS导出路径
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MedsReport.xls";
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		var OccDate=retvalArr[4]
		var SelDateArr="",SelYear="",SelMonth="",SelDate="";
		if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY
			SelDateArr=OccDate.split("/");
			SelYear=SelDateArr[2];
			SelMonth=parseInt(SelDateArr[1])-1;
			SelDate=parseInt(SelDateArr[0]);
		}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
			SelDateArr=OccDate.split("-");
			SelYear=SelDateArr[0];
			SelMonth=parseInt(SelDateArr[1])-1;
			SelDate=parseInt(SelDateArr[2]);
		}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
			SelDateArr=OccDate.split("/");
			SelYear=SelDateArr[2];
			SelMonth=parseInt(SelDateArr[0])-1;
			SelDate=parseInt(SelDateArr[1]);
		}
		var dt = new Date(SelYear,SelMonth,SelDate), dt2 = new Date();
		var weekDay = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
		var weekday=weekDay[dt.getDay()];
		objSheet.Cells(2,2).value=retvalArr[19]; //报告编码
		objSheet.Cells(2,7).value=retvalArr[2]+" "+retvalArr[3]; //报告日期
		objSheet.Cells(3,2).value=retvalArr[4]+" "+retvalArr[5]; //发生日期
		objSheet.Cells(3,7).value=weekday; //星期
		objSheet.Cells(3,9).value=retvalArr[6]; //班次
		
		objSheet.Cells(4,2).value=retvalArr[8]; //病人ID
		objSheet.Cells(4,7).value=retvalArr[7]; //病人病案号
		objSheet.Cells(5,2).value=retvalArr[9]; //病人姓名
		objSheet.Cells(5,7).value=retvalArr[10]; //病人性别
		objSheet.Cells(5,9).value=retvalArr[11]; //病人年龄
		
		objSheet.Cells(6,2).value=retvalArr[12]; //应给药物
		objSheet.Cells(6,7).value=retvalArr[13]; //药物剂量
		objSheet.Cells(6,9).value=retvalArr[17]; //累计给药错误次数
		
		var MULtmpStr=retvalArr[22];  //环节信息
		var tmpStr=MULtmpStr.split("!!");
		for (i=0;i<tmpStr.length;i++){
			var tmpList=tmpStr[i].split("&");
			if(tmpList[0]=="DocL"){ //医生环节
				DocList=tmpList;
			}else if(tmpList[0]=="ApoL"){
				ApoList=tmpList;
			}else if(tmpList[0]=="DispL"){
				DispList=tmpList;
			}else if(tmpList[0]=="NurL"){
				NurList=tmpList;
			}else if(tmpList[0]=="PatL"){
				PatList=tmpList;
			}	
		}
		//医生环节		
		xlApp.Range(xlApp.Cells(8,1),xlApp.Cells(8,9)).MergeCells = true; //合并单元格
		objSheet.Cells(8,1).value="医生环节";
		objSheet.Cells(8,1).Interior.Pattern = 2;  //设置单元格背景样式*(1-无，2-细网格，3-粗网格，4-斑点，5-横线，6-竖线..)
		objSheet.Cells(9,1).value="是否选中";
		objSheet.Cells(9,2).value="代码";
		xlApp.Range(xlApp.Cells(9,3),xlApp.Cells(9,6)).MergeCells = true;  //合并单元格
		objSheet.Cells(9,3).value="描述";
		objSheet.Cells(9,7).value="应当是";
		objSheet.Cells(9,8).value="错误是";
		objSheet.Cells(9,9).value="其他";
		
		Doclen=DocList.length-1;
		for(var k=1;k<=Doclen;k++){
			var MULIDoArr=DocList[k].split("^");
			objSheet.Cells(9+k,1).value=MULIDoArr[0]; //是否选中
			objSheet.Cells(9+k,2).value=MULIDoArr[2]; //代码
			xlApp.Range(xlApp.Cells(9+k,3),xlApp.Cells(9+k,6)).MergeCells = true;  //合并单元格
			objSheet.Cells(9+k,3).value=MULIDoArr[3]; //描述
			objSheet.Cells(9+k,7).value=MULIDoArr[5]; //应当是
			objSheet.Cells(9+k,7).WrapText=true;  
			objSheet.Cells(9+k,8).value=MULIDoArr[6]; //错误是
			objSheet.Cells(9+k,8).WrapText=true;  
			objSheet.Cells(9+k,9).value=MULIDoArr[7]; //其他
		}
		
		//药师环节		
		xlApp.Range(xlApp.Cells(10+Doclen+3,1),xlApp.Cells(10+Doclen+3,9)).MergeCells = true;
		objSheet.Cells(10+Doclen+3,1).value="药师环节";
		objSheet.Cells(10+Doclen+3,1).Interior.Pattern = 2; 
		objSheet.Cells(10+Doclen+4,1).value="是否选中";
		objSheet.Cells(10+Doclen+4,2).value="代码";
		xlApp.Range(xlApp.Cells(10+Doclen+4,3),xlApp.Cells(10+Doclen+4,6)).MergeCells = true;
		objSheet.Cells(10+Doclen+4,3).value="描述";
		objSheet.Cells(10+Doclen+4,7).value="应当是";
		objSheet.Cells(10+Doclen+4,8).value="错误是";
		objSheet.Cells(10+Doclen+4,9).value="其他";
		
		Apolen=ApoList.length-1;
		for(var k=1;k<=Apolen;k++){
			var MULIApArr=ApoList[k].split("^");
			objSheet.Cells(10+Doclen+4+k,1).value=MULIApArr[0]; //是否选中
			objSheet.Cells(10+Doclen+4+k,2).value=MULIApArr[2]; //代码
			xlApp.Range(xlApp.Cells(10+Doclen+4+k,3),xlApp.Cells(10+Doclen+4+k,6)).MergeCells = true;
			objSheet.Cells(10+Doclen+4+k,3).value=MULIApArr[3]; //描述
			objSheet.Cells(10+Doclen+4+k,7).value=MULIApArr[5]; //应当是
			objSheet.Cells(10+Doclen+4+k,7).WrapText=true;  
			objSheet.Cells(10+Doclen+4+k,8).value=MULIApArr[6]; //错误是
			objSheet.Cells(10+Doclen+4+k,8).WrapText=true;  
			objSheet.Cells(10+Doclen+4+k,9).value=MULIApArr[7]; //其他
		}
		DAlen=Doclen+Apolen;
		
		//配送环节		
		xlApp.Range(xlApp.Cells(10+DAlen+8,1),xlApp.Cells(10+DAlen+8,9)).MergeCells = true;
		objSheet.Cells(10+DAlen+8,1).value="配送环节";
		objSheet.Cells(10+DAlen+8,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DAlen+9,1).value="是否选中";
		objSheet.Cells(10+DAlen+9,2).value="代码";
		xlApp.Range(xlApp.Cells(10+DAlen+9,3),xlApp.Cells(10+DAlen+9,6)).MergeCells = true;
		objSheet.Cells(10+DAlen+9,3).value="描述";
		objSheet.Cells(10+DAlen+9,7).value="应当是";
		objSheet.Cells(10+DAlen+9,8).value="错误是";
		objSheet.Cells(10+DAlen+9,9).value="其他";

		Displen=DispList.length-1;
		for(var k=1;k<=Displen;k++){
			var MULIDiArr=DispList[k].split("^");
			objSheet.Cells(10+DAlen+9+k,1).value=MULIDiArr[0]; //是否选中
			objSheet.Cells(10+DAlen+9+k,2).value=MULIDiArr[2]; //代码
			xlApp.Range(xlApp.Cells(10+DAlen+9+k,3),xlApp.Cells(10+DAlen+9+k,6)).MergeCells = true;
			objSheet.Cells(10+DAlen+9+k,3).value=MULIDiArr[3]; //描述
			objSheet.Cells(10+DAlen+9+k,7).value=MULIDiArr[5]; //应当是
			objSheet.Cells(10+DAlen+9+k,7).WrapText=true;  
			objSheet.Cells(10+DAlen+9+k,8).value=MULIDiArr[6]; //错误是
			objSheet.Cells(10+DAlen+9+k,8).WrapText=true;  
			objSheet.Cells(10+DAlen+9+k,9).value=MULIDiArr[7]; //其他
		}
		DADilen=DAlen+Displen;
		
		//护士环节		
		xlApp.Range(xlApp.Cells(10+DADilen+11,1),xlApp.Cells(10+DADilen+11,9)).MergeCells = true;
		objSheet.Cells(10+DADilen+11,1).value="护士环节";
		objSheet.Cells(10+DADilen+11,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DADilen+12,1).value="是否选中";
		objSheet.Cells(10+DADilen+12,2).value="代码";
		xlApp.Range(xlApp.Cells(10+DADilen+12,3),xlApp.Cells(10+DADilen+12,6)).MergeCells = true;
		objSheet.Cells(10+DADilen+12,3).value="描述";
		objSheet.Cells(10+DADilen+12,7).value="应当是";
		objSheet.Cells(10+DADilen+12,8).value="错误是";
		objSheet.Cells(10+DADilen+12,9).value="其他";

		Nuslen=NurList.length-1;
		for(var k=1;k<=Nuslen;k++){
			var MULINuArr=NurList[k].split("^");
			objSheet.Cells(10+DADilen+12+k,1).value=MULINuArr[0]; //是否选中
			objSheet.Cells(10+DADilen+12+k,2).value=MULINuArr[2]; //代码
			xlApp.Range(xlApp.Cells(10+DADilen+12+k,3),xlApp.Cells(10+DADilen+12+k,6)).MergeCells = true;
			objSheet.Cells(10+DADilen+12+k,3).value=MULINuArr[3]; //描述
			objSheet.Cells(10+DADilen+12+k,7).value=MULINuArr[5]; //应当是
			objSheet.Cells(10+DADilen+12+k,7).WrapText=true;  
			objSheet.Cells(10+DADilen+12+k,8).value=MULINuArr[6]; //错误是
			objSheet.Cells(10+DADilen+12+k,8).WrapText=true;  
			objSheet.Cells(10+DADilen+12+k,9).value=MULINuArr[7]; //其他
		}
		DADiNulen=DADilen+Nuslen;
		
		//患者环节		
		xlApp.Range(xlApp.Cells(10+DADiNulen+16,1),xlApp.Cells(10+DADiNulen+16,9)).MergeCells = true;
		objSheet.Cells(10+DADiNulen+16,1).value="患者环节";
		objSheet.Cells(10+DADiNulen+16,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DADiNulen+17,1).value="是否选中";
		objSheet.Cells(10+DADiNulen+17,2).value="代码";
		xlApp.Range(xlApp.Cells(10+DADiNulen+17,3),xlApp.Cells(10+DADiNulen+17,6)).MergeCells = true;
		objSheet.Cells(10+DADiNulen+17,3).value="描述";
		objSheet.Cells(10+DADiNulen+17,7).value="应当是";
		objSheet.Cells(10+DADiNulen+17,8).value="错误是";
		objSheet.Cells(10+DADiNulen+17,9).value="其他";

		var Patlen=PatList.length-1;
		for(var k=1;k<=Patlen;k++){
			var MULIPaArr=PatList[k].split("^");
			objSheet.Cells(10+DADiNulen+17+k,1).value=MULIPaArr[0]; //是否选中
			objSheet.Cells(10+DADiNulen+17+k,2).value=MULIPaArr[2]; //代码
			xlApp.Range(xlApp.Cells(10+DADiNulen+17+k,3),xlApp.Cells(10+DADiNulen+17+k,6)).MergeCells = true;
			objSheet.Cells(10+DADiNulen+17+k,3).value=MULIPaArr[3]; //描述
			objSheet.Cells(10+DADiNulen+17+k,7).value=MULIPaArr[5]; //应当是
			objSheet.Cells(10+DADiNulen+17+k,7).WrapText=true;  
			objSheet.Cells(10+DADiNulen+17+k,8).value=MULIPaArr[6]; //错误是
			objSheet.Cells(10+DADiNulen+17+k,8).WrapText=true;  
			objSheet.Cells(10+DADiNulen+17+k,9).value=MULIPaArr[7]; //其他
		}
		DADiNuPalen=DADiNulen+Patlen;
		
		//当事医生、药师、护士信息
		var MedsRepLinkList=retvalArr[21];  
		var RepLinkList=MedsRepLinkList.split("&");
		for (i=0;i<RepLinkList.length;i++){
			var messList=RepLinkList[i].split("^");
			var medsrMes=""
			if (messList[4]=="DocL"){
				xlApp.Range(xlApp.Cells(10+Doclen+1,1),xlApp.Cells(10+Doclen+1,2)).MergeCells = true;
				objSheet.Cells(10+Doclen+1,1).value="当事医生信息：";
				xlApp.Range(xlApp.Cells(10+Doclen+1,3),xlApp.Cells(10+Doclen+1,9)).MergeCells = true;
				if(messList[1]==10){
					medsrMes="正式医生";
				}else if(messList[1]==11){
					medsrMes="研究生";
				}else if(messList[1]==12){
					medsrMes="进修医生";
				}
				objSheet.Cells(10+Doclen+1,3).value=medsrMes+" "+messList[2]+" "+messList[3];  //当事医生信息
			}else if(messList[4]=="ApoL"){
				xlApp.Range(xlApp.Cells(10+DAlen+6,1),xlApp.Cells(10+DAlen+6,2)).MergeCells = true;
				objSheet.Cells(10+DAlen+6,1).value="当事药师信息：";
				xlApp.Range(xlApp.Cells(10+DAlen+6,3),xlApp.Cells(10+DAlen+6,9)).MergeCells = true;
				if(messList[1]==20){
					medsrMes="正式药师";
				}else if(messList[1]==21){
					medsrMes="实习生";
				}else if(messList[1]==22){
					medsrMes="进修药师";
				}
				objSheet.Cells(10+DAlen+6,3).value=medsrMes+" "+messList[2]+" "+messList[3]; //当事药师信息
			}else if(messList[4]=="NurL"){
				xlApp.Range(xlApp.Cells(10+DADiNulen+14,1),xlApp.Cells(10+DADiNulen+14,2)).MergeCells = true;
				objSheet.Cells(10+DADiNulen+14,1).value="当事护士信息：";
				xlApp.Range(xlApp.Cells(10+DADiNulen+14,3),xlApp.Cells(10+DADiNulen+14,9)).MergeCells = true;
				objSheet.Cells(10+DADiNulen+14,3).value=retvalArr[27]+" "+retvalArr[28]+" "+retvalArr[29]; //当事护士信息
				if(messList[1]==30){
					medsrMes="正式护士";
				}else if(messList[1]==31){
					medsrMes="实习生";
				}else if(messList[1]==32){
					medsrMes="进修护士";
				}
				objSheet.Cells(10+DADiNulen+14,3).value=medsrMes+" "+messList[2]+" "+messList[3]; //当事护士信息
			}
		}
		
		xlApp.Range(8+":"+(10+DADiNuPalen+18)).HorizontalAlignment = 2; 
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+19,1),xlApp.Cells(10+DADiNuPalen+19,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Size = 16; //设置为16号字
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Name = "宋体"; 
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Bold = true; //设置为粗体
		objSheet.Cells(10+DADiNuPalen+19,1).value="后果："; 
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+20,1),xlApp.Cells(10+DADiNuPalen+20,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+20,1).value=retvalArr[23]+retvalArr[24]; //后果
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+21,1),xlApp.Cells(10+DADiNuPalen+21,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Size = 16; //设置为16号字
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Name = "宋体"; 
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Bold = true; //设置为粗体
		objSheet.Cells(10+DADiNuPalen+21,1).value="即时行动/干预："; 
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+22,1),xlApp.Cells(10+DADiNuPalen+27,9)).MergeCells = true;
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+22,1),xlApp.Cells(10+DADiNuPalen+27,9)).WrapText=true; //自动换行
		objSheet.Cells(10+DADiNuPalen+22,1).value=retvalArr[14];  //即时行动、干预
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,1),xlApp.Cells(10+DADiNuPalen+28,4)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,1).value="报告科室："+retvalArr[1];
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,6),xlApp.Cells(10+DADiNuPalen+28,7)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,6).value="报告人姓名："+retvalArr[15];
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,8),xlApp.Cells(10+DADiNuPalen+28,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,8).value="报告人职称："+retvalArr[16]; //报告人职称
					
		
		xlBook.SaveAs(filePath+retvalArr[19]+".xls");
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(TypeCode=="blood"){
		var retval=tkMakeServerCall("web.DHCADVBLDREPORT","getBldRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1、获取XLS打印路径
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_BloodReport.xls";
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		objSheet.Cells(2,2).value=retvalArr[3]; //报告编码
		objSheet.Cells(2,6).value=retvalArr[4]+" "+retvalArr[5]; //报告日期
		objSheet.Cells(3,2).value=retvalArr[6]; //病区
		objSheet.Cells(3,6).value=retvalArr[1]; //科室
		
		objSheet.Cells(5,1).Interior.Pattern = 2; 
		objSheet.Cells(6,2).value=retvalArr[9]; //病人ID
		objSheet.Cells(6,5).value=retvalArr[8]; //病人病案号
		objSheet.Cells(7,2).value=retvalArr[10]; //病人姓名
		objSheet.Cells(7,5).value=retvalArr[11]; //病人性别
		objSheet.Cells(7,8).value=retvalArr[12]; //病人年龄
		objSheet.Cells(8,2).value=retvalArr[13]; //出生日期
		objSheet.Cells(8,5).value=retvalArr[14]; //身份证号
		objSheet.Cells(9,3).value=retvalArr[51]; //病床诊断/手术名称
		
		objSheet.Cells(10,8).value=retvalArr[15]; //孕产史
		objSheet.Cells(10,2).value=retvalArr[16]; //继往输血史
		objSheet.Cells(10,5).value=retvalArr[17]; //输血反应史
		objSheet.Cells(11,3).value=retvalArr[18]; //输血前血型检查结果
		objSheet.Cells(11,5).value=retvalArr[19]; //阴阳性
		objSheet.Cells(11,8).value=retvalArr[20]; //意外抗体筛查（阴阳性）
		objSheet.Cells(12,3).value=retvalArr[21]; //本次输注的血液信息
		objSheet.Cells(12,5).value=retvalArr[22]; //阴阳性
		objSheet.Cells(13,2).value=retvalArr[23]; //输注血量
		objSheet.Cells(14,1).Interior.Pattern = 2; 
		var bldrptBldType=retvalArr[50];  //患者体征
		var BldTypeArr=bldrptBldType.split("&");
		var BldTypelen=BldTypeArr.length;
		for(var k=0;k<BldTypelen;k++){
			var BldType=BldTypeArr[k].split("^");
			objSheet.Cells(16+k,1).value=BldType[1]; //输血类别
			xlApp.Range(xlApp.Cells(15+k,2),xlApp.Cells(15+k,3)).MergeCells = true;
			objSheet.Cells(16+k,2).value=BldType[3]; //输血编号1
			objSheet.Cells(16+k,4).value=BldType[4]; //输血编号2
			objSheet.Cells(16+k,5).value=BldType[5]; //输血编号3
			xlApp.Range(xlApp.Cells(16+k,6),xlApp.Cells(16+k,7)).MergeCells = true;
			objSheet.Cells(16+k,6).value=BldType[6]; //输血编号1
		}
		
		xlApp.Range(xlApp.Cells(16+BldTypelen,1),xlApp.Cells(16+BldTypelen,8)).MergeCells = true;
		objSheet.Cells(16+BldTypelen,1).value="输血不良反应描述";
		objSheet.Cells(16+BldTypelen,1).Font.Size = 12; //设置为12号字
		objSheet.Cells(16+BldTypelen,1).Font.Name = "宋体"; 
		objSheet.Cells(16+BldTypelen,1).Font.Bold = true; //设置为粗体
		objSheet.Cells(16+BldTypelen,1).Interior.Pattern = 2; 
		xlApp.Range(xlApp.Cells(17+BldTypelen,1),xlApp.Cells(17+BldTypelen,4)).MergeCells = true;
		xlApp.Range(xlApp.Cells(17+BldTypelen,5),xlApp.Cells(17+BldTypelen,8)).MergeCells = true;
		objSheet.Cells(17+BldTypelen,1).value="患者体征";
		objSheet.Cells(17+BldTypelen,5).value="临床症状";
		
		
		var bldrptBldBasA=retvalArr[48];  //患者体征
		var BldBasArr=bldrptBldBasA.split("&");
		var BldBasAlen=BldBasArr.length;
		var BBasAlen=Math.ceil(BldBasAlen/2);
		for(var k=0;k<BBasAlen;k++){
			var BldB=BldBasArr[k].split("^");
			xlApp.Range(xlApp.Cells(18+BldTypelen+k,1),xlApp.Cells(18+BldTypelen+k,2)).MergeCells = true;
			objSheet.Cells(18+BldTypelen+k,1).value=BldB[0]+" "+BldB[1]; //是否选中
 			var i=BBasAlen+k;
 			if(i<BldBasAlen){
				var BldBi=BldBasArr[i].split("^");
				xlApp.Range(xlApp.Cells(18+BldTypelen+k,3),xlApp.Cells(18+BldTypelen+k,4)).MergeCells = true;
				objSheet.Cells(18+BldTypelen+k,3).value=BldBi[0]+" "+BldBi[1]; //描述
			}
		}
		var bldrptBldBasB=retvalArr[49];  //临床症状
		var BldBasBArr=bldrptBldBasB.split("&");
		var BldBasBlen=BldBasBArr.length;
		var BBasBlen=Math.ceil(BldBasBlen/2) ;
		for(var k=0;k<BBasBlen;k++){
			var BldB=BldBasBArr[k].split("^");
			xlApp.Range(xlApp.Cells(18+BldTypelen+k,5),xlApp.Cells(18+BldTypelen+k,6)).MergeCells = true;
			objSheet.Cells(18+BldTypelen+k,5).value=BldB[0]+" "+BldB[1]; //是否选中
 			var j=BBasBlen+k;
 			if(j<BldBasBlen){
				var BldBj=BldBasBArr[j].split("^");
				xlApp.Range(xlApp.Cells(18+BldTypelen+k,7),xlApp.Cells(18+BldTypelen+k,8)).MergeCells = true;
				objSheet.Cells(18+BldTypelen+k,7).value=BldBj[0]+" "+BldBj[1]; //描述
			}
		}
		if(BBasAlen>BBasBlen){
			BBasBlen=BBasAlen;
		}
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen,1),xlApp.Cells(18+BldTypelen+BBasBlen,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Size = 12; //设置为12号字
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Name = "宋体"; 
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Bold = true; //设置为粗体
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Interior.Pattern = 2; 
		objSheet.Cells(18+BldTypelen+BBasBlen,1).value="基本生命体征"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,1).value="体温："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,2).value=retvalArr[24]; //体温
		objSheet.Cells(18+BldTypelen+BBasBlen+1,3).value="血压："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,4).value=retvalArr[25]; //血压
		objSheet.Cells(18+BldTypelen+BBasBlen+1,5).value="脉搏："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,6).value=retvalArr[26]; //脉搏
		objSheet.Cells(18+BldTypelen+BBasBlen+1,7).value="呼吸频次："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,8).value=retvalArr[27]; //呼吸频次
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+2,1),xlApp.Cells(18+BldTypelen+BBasBlen+2,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+2,1).value="输血前预防用药："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+2,3),xlApp.Cells(18+BldTypelen+BBasBlen+2,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+2,3).value=retvalArr[28]+" "+retvalArr[29];  //输血前预防用药
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,1),xlApp.Cells(18+BldTypelen+BBasBlen+3,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,1).value="本次输血开始时间："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,3),xlApp.Cells(18+BldTypelen+BBasBlen+3,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,3).value=retvalArr[30]+" "+retvalArr[31]; //本次输血开始时间
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,6),xlApp.Cells(18+BldTypelen+BBasBlen+3,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,6).value="操作者工号："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+3,8).value=retvalArr[32]; //操作者工号
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,1),xlApp.Cells(18+BldTypelen+BBasBlen+4,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,1).value="输血反应发现时间："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,3),xlApp.Cells(18+BldTypelen+BBasBlen+4,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,3).value=retvalArr[33]+" "+retvalArr[34]; //输血反应发现时间
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,6),xlApp.Cells(18+BldTypelen+BBasBlen+4,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,6).value="发现者工号："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+4,8).value=retvalArr[35]; //发现者工号
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,1),xlApp.Cells(18+BldTypelen+BBasBlen+5,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,1).value="输血器厂家/批号："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,3),xlApp.Cells(18+BldTypelen+BBasBlen+5,5)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,3).value=retvalArr[36]; //输血器厂家/批号
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,6),xlApp.Cells(18+BldTypelen+BBasBlen+5,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,6).value="剩余血量(ml)："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+5,8).value=retvalArr[37]; //剩余血量
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,1),xlApp.Cells(18+BldTypelen+BBasBlen+6,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,1).value="严重程度："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,3),xlApp.Cells(18+BldTypelen+BBasBlen+6,5)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,3).value=retvalArr[39]; //严重程度
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,6),xlApp.Cells(18+BldTypelen+BBasBlen+6,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,6).value="相关性："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+6,8).value=retvalArr[40]; //相关性
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+7,1),xlApp.Cells(18+BldTypelen+BBasBlen+7,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+7,1).value="输血不良反应拟诊："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+7,3),xlApp.Cells(18+BldTypelen+BBasBlen+7,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+7,3).value=retvalArr[38]; //输血不良反应拟诊
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+8,1),xlApp.Cells(18+BldTypelen+BBasBlen+8,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Size = 12; //设置为12号字
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Name = "宋体"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Bold = true; //设置为粗体
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Interior.Pattern = 2; 
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).value="临床处置："; 
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+9,1),xlApp.Cells(18+BldTypelen+BBasBlen+12,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+9,1).value=retvalArr[41]; //临床处置
		
		objSheet.Cells(18+BldTypelen+BBasBlen+13,1).value="患者转归："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+13,2),xlApp.Cells(18+BldTypelen+BBasBlen+13,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+13,2).value=retvalArr[42]+" "+retvalArr[43]+" "+retvalArr[44];  //患者转归
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+14,1),xlApp.Cells(18+BldTypelen+BBasBlen+14,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+14,1).value="与输血相关性："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+14,3),xlApp.Cells(18+BldTypelen+BBasBlen+14,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+14,3).value=retvalArr[45]; //与输血相关性
	
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+15,5),xlApp.Cells(18+BldTypelen+BBasBlen+15,6)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+15,5).value="报告人签名："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+15,7),xlApp.Cells(18+BldTypelen+BBasBlen+15,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+15,7).value=retvalArr[2]; //填报人

		
		xlBook.SaveAs(filePath+retvalArr[3]+".xls");
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(TypeCode=="drug"){
		var retval=tkMakeServerCall("web.DHCADVMADRREPORT","getMadrRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1、获取XLS打印路径
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_DrugReport.xls";
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		/*
		objSheet.Cells(2,2).value=retvalArr[0]+" "+retvalArr[1]; //报告日期
		objSheet.Cells(2,7).value=retvalArr[2]; //报告编码
	
		objSheet.Cells(3,2).value=retvalArr[3]; //病人ID
		objSheet.Cells(3,5).value=retvalArr[4]; //性别
		objSheet.Cells(3,7).value=retvalArr[5]; //民族
		objSheet.Cells(3,9).value=retvalArr[6]; //出生日期
		objSheet.Cells(4,2).value=retvalArr[7]; //患者姓名
		objSheet.Cells(4,4).value=retvalArr[8]; //病案号
		objSheet.Cells(4,7).value=retvalArr[9]+" "+"Kg"; //体重
		objSheet.Cells(4,9).value=retvalArr[10]; //联系方式
		objSheet.Cells(5,2).value=retvalArr[11]; //既往药品不良反应/事件
		objSheet.Cells(5,3).value=retvalArr[12]; //既往药品不良反应/事件描述
		
		objSheet.Cells(5,7).value=retvalArr[13]; //家族药品不良反应/事件
		objSheet.Cells(5,8).value=retvalArr[14]; //家族药品不良反应/事件描述
		objSheet.Cells(6,3).value=retvalArr[15]; //相关重要信息
		objSheet.Cells(6,9).value=retvalArr[30]; //相关重要信息其他
		objSheet.Cells(8,1).value=retvalArr[16]; //不良反应/事件过程描述
		objSheet.Cells(13,4).value=retvalArr[17]+" "+retvalArr[18]; //不良反应/事件发生时间
		objSheet.Cells(14,3).value=retvalArr[19]; //不良反应/事件的结果
	    objSheet.Cells(14,6).value=retvalArr[20];   //事件的结果描述
	    objSheet.Cells(14,9).value=retvalArr[21]+" "+retvalArr[22];   //死亡时间
		objSheet.Cells(15,3).value=retvalArr[23]; //联系人电话
		objSheet.Cells(15,6).value=retvalArr[24]; //职业
		objSheet.Cells(15,9).value=retvalArr[25]; //其他
		
		objSheet.Cells(16,3).value=retvalArr[26]; //电子邮箱
		objSheet.Cells(16,6).value=retvalArr[27]; //签名
		objSheet.Cells(16,8).value=retvalArr[28]; //报告部门
		objSheet.Cells(17,2).value=retvalArr[29]; //备注*/
		
		objSheet.Cells(2,2).value=retvalArr[0]; //报告状态
		objSheet.Cells(2,9).value=retvalArr[1]; //编号
		objSheet.Cells(3,2).value=retvalArr[2]+" "+retvalArr[3]+""+retvalArr[4]; //类型
		objSheet.Cells(3,7).value=retvalArr[5]+retvalArr[6]; //报告单位类别
		objSheet.Cells(4,2).value=retvalArr[7]; //患者姓名
		objSheet.Cells(4,4).value=retvalArr[8]; //性别
		objSheet.Cells(4,6).value=retvalArr[9]; //出生日期
		objSheet.Cells(4,8).value=retvalArr[10]; //民族
		if(retvalArr[11]!=""){
		  objSheet.Cells(4,10).value=retvalArr[11]+" "+"Kg"; //体重
		}else{
		  objSheet.Cells(4,10).value=retvalArr[11]; //体重
		}
		objSheet.Cells(4,12).value=retvalArr[12]; //联系方式
		objSheet.Cells(5,2).value=retvalArr[13]; //原患疾病
		objSheet.Cells(5,5).value=retvalArr[14]; //医院名称
		objSheet.Cells(5,9).value=retvalArr[15]+retvalArr[16]; //既往药品不良反应/事件
		objSheet.Cells(6,5).value=retvalArr[17]; //病历号/门诊号
		objSheet.Cells(6,9).value=retvalArr[18]+retvalArr[19]; //家族药品不良反应/事件
		objSheet.Cells(7,2).value=retvalArr[20]+retvalArr[21]; //相关重要信息
		objSheet.Cells(8,3).value=retvalArr[22];  //不良反应/事件名称
		objSheet.Cells(8,10).value=retvalArr[23]+"  "+retvalArr[24]; //不良反应/事件发生时间
		objSheet.Cells(10,1).value=retvalArr[25]; //不良反应/事件过程描述
		objSheet.Cells(11,3).value=retvalArr[26]; //不良反应/事件的结果
		objSheet.Cells(11,7).value=retvalArr[27]; //表现/直接死因
		objSheet.Cells(11,11).value=retvalArr[28]+"  "+retvalArr[29]; //死亡时间
		objSheet.Cells(12,5).value=retvalArr[30]; //停药或减量后，反应/事件是否消失或减轻？
		objSheet.Cells(13,5).value=retvalArr[31]; //再次使用可疑药品后是否再次出现同样反应/事件
		objSheet.Cells(14,5).value=retvalArr[32]; //对原患疾病的影响
		objSheet.Cells(15,3).value=retvalArr[33]; //报告人评价
		objSheet.Cells(15,11).value=retvalArr[34]; //签名
		objSheet.Cells(16,3).value=retvalArr[35];  //报告单位评价
		objSheet.Cells(16,11).value=retvalArr[36]; //签名
		objSheet.Cells(17,3).value=retvalArr[37]; //联系电话
		objSheet.Cells(17,11).value=retvalArr[38]+retvalArr[39]; //职业
		objSheet.Cells(18,3).value=retvalArr[40]; //电子邮箱
		objSheet.Cells(18,6).value=retvalArr[41]; //签名
		objSheet.Cells(18,11).value=retvalArr[42]; //报告部门
		objSheet.Cells(19,3).value=retvalArr[43]; //单位名称
		objSheet.Cells(19,6).value=retvalArr[44]; //联系人
		objSheet.Cells(19,8).value=retvalArr[45]; //电话
		objSheet.Cells(19,11).value=retvalArr[46]+"  "+retvalArr[47]; //报告日期
		objSheet.Cells(20,2).value=retvalArr[48]; //备注
	   xlApp.Range(objSheet.Cells(22,1),objSheet.Cells(22,12)).Interior.Pattern = 2; //药品列表标题背景颜色
	   	var advRepDrgItmList=retvalArr[49];  //药品列表

	   var advRepDrgItmArr=advRepDrgItmList.split("||");
	    for(var k=0;k<advRepDrgItmArr.length;k++){
		var drgItmArr=advRepDrgItmArr[k].split("^");
		objSheet.Cells(23+k,1).value=drgItmArr[0]; //类型
		objSheet.Cells(23+k,2).value="'"+drgItmArr[1]; //批准文号
		objSheet.Cells(23+k,3).value=drgItmArr[3]; //商品名称
		objSheet.Cells(23+k,4).value=drgItmArr[8]; //通用名
		objSheet.Cells(23+k,6).value=drgItmArr[5]; //厂家
		objSheet.Cells(23+k,7).value="'"+drgItmArr[17]; //批号
		objSheet.Cells(23+k,8).value="'"+drgItmArr[9]; //用法用量
		objSheet.Cells(23+k,9).value="'"+drgItmArr[13]; //开始时间
		objSheet.Cells(23+k,11).value="'"+drgItmArr[14]; //结束时间
		objSheet.Cells(23+k,12).value="'"+drgItmArr[16]; //用药原因
	}  
        
		
		xlBook.SaveAs(filePath+retvalArr[1]+".xls");
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(TypeCode=="med"||TypeCode=="bldevent"){
		var retval=tkMakeServerCall("web.DHCADVMEDADRREPORT","getMedRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1、获取XLS打印路径
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MedAdrReport.xls";
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		objSheet.Cells(2,2).value=retvalArr[0]+" "+retvalArr[1]; //报告日期
		objSheet.Cells(2,7).value=retvalArr[2]; //报告编码

		objSheet.Cells(4,2).value=retvalArr[3]; //病人ID
		objSheet.Cells(4,5).value=retvalArr[4]; //病区
		objSheet.Cells(4,9).value=retvalArr[5]; //病案号
		objSheet.Cells(5,2).value=retvalArr[6]; //患者姓名
		objSheet.Cells(5,5).value=retvalArr[7]; //性别
		objSheet.Cells(5,8).value=retvalArr[8]; //年龄
		objSheet.Cells(6,2).value=retvalArr[9]; //临床诊断
		var adrAnonymFlag="" ,adrRepUser="" ,adradrRepDept="";
		if (retvalArr[10]==1){
			adrAnonymFlag="匿名";
			adrRepUser="" ;
			adradrRepDept="";
		 }else{
			 adrAnonymFlag=""
			 adrRepUser=retvalArr[11] ;
			 adradrRepDept=retvalArr[12];
		 
		 }
		
		objSheet.Cells(8,2).value=adrAnonymFlag; //匿名
		objSheet.Cells(8,7).value=adrRepUser; //报告人姓名
		objSheet.Cells(9,2).value=adradrRepDept; //报告部门
		objSheet.Cells(9,7).value=retvalArr[25]+" "+retvalArr[26]; //事件发生日期时间
		objSheet.Cells(10,3).value=retvalArr[15]; //上报人职业类别
		
		objSheet.Cells(10,8).value=retvalArr[16]; //上报人职称
		objSheet.Cells(11,2).value=retvalArr[17]; //联系电话
		objSheet.Cells(11,8).value=retvalArr[18]; //电子邮件
		objSheet.Cells(13,3).value=retvalArr[19]; //事件报告类型
		objSheet.Cells(13,7).value=retvalArr[20]+" "+retvalArr[21]; //事件发生地点
		//objSheet.Cells(13,9).value=retvalArr[21]; //地点其他
		objSheet.Cells(15,1).value=retvalArr[22]; //事件过程描述
	    objSheet.Cells(22,1).value=retvalArr[23];   //存在隐患
	    objSheet.Cells(28,1).value=retvalArr[24];   //改进建议

	   
		xlBook.SaveAs(filePath+retvalArr[2]+".xls");
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
}

/// 打印
function printRep(ID,typecode)
{
	if(ID==""){
		$.messager.alert("提示:","报表ID为空！");
		return;
	}
	if(typecode=="material"){
		var retval=tkMakeServerCall("web.DHCADVMEDREPORT","getMataRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		}
		var retvalArr=retval.split("&&");
		//1、获取XLS打印路径
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MataReport.xls";
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
		objSheet.printout();
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(typecode=="drugerr"){
		var retval=tkMakeServerCall("web.DHCADVMEDSAREPORT","getMedsRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		}
		var retvalArr=retval.split("&&");
		//1、获取XLS打印路径
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MedsReport.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		var OccDate=retvalArr[4]
		var SelDateArr="",SelYear="",SelMonth="",SelDate="";
		if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY
			SelDateArr=OccDate.split("/");
			SelYear=SelDateArr[2];
			SelMonth=parseInt(SelDateArr[1])-1;
			SelDate=parseInt(SelDateArr[0]);
		}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
			SelDateArr=OccDate.split("-");
			SelYear=SelDateArr[0];
			SelMonth=parseInt(SelDateArr[1])-1;
			SelDate=parseInt(SelDateArr[2]);
		}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
			SelDateArr=OccDate.split("/");
			SelYear=SelDateArr[2];
			SelMonth=parseInt(SelDateArr[0])-1;
			SelDate=parseInt(SelDateArr[1]);
		}
		var dt = new Date(SelYear,SelMonth,SelDate), dt2 = new Date();
		var weekDay = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
		var weekday=weekDay[dt.getDay()];
		
		objSheet.Cells(2,2).value=retvalArr[19]; //报告编码
		objSheet.Cells(2,7).value=retvalArr[2]+" "+retvalArr[3]; //报告日期
		objSheet.Cells(3,2).value=retvalArr[4]+" "+retvalArr[5]; //发生日期
		objSheet.Cells(3,7).value=weekday; //星期
		objSheet.Cells(3,9).value=retvalArr[6]; //班次
		
		objSheet.Cells(4,2).value=retvalArr[8]; //病人ID
		objSheet.Cells(4,7).value=retvalArr[7]; //病人病案号
		objSheet.Cells(5,2).value=retvalArr[9]; //病人姓名
		objSheet.Cells(5,7).value=retvalArr[10]; //病人性别
		objSheet.Cells(5,9).value=retvalArr[11]; //病人年龄
		
		objSheet.Cells(6,2).value=retvalArr[12]; //应给药物
		objSheet.Cells(6,7).value=retvalArr[13]; //药物剂量
		objSheet.Cells(6,9).value=retvalArr[17]; //累计给药错误次数
		
		var MULtmpStr=retvalArr[22];  //环节信息
		var tmpStr=MULtmpStr.split("!!");
		for (i=0;i<tmpStr.length;i++){
			var tmpList=tmpStr[i].split("&");
			if(tmpList[0]=="DocL"){ //医生环节
				DocList=tmpList;
			}else if(tmpList[0]=="ApoL"){
				ApoList=tmpList;
			}else if(tmpList[0]=="DispL"){
				DispList=tmpList;
			}else if(tmpList[0]=="NurL"){
				NurList=tmpList;
			}else if(tmpList[0]=="PatL"){
				PatList=tmpList;
			}	
		}
		//医生环节		
		xlApp.Range(xlApp.Cells(8,1),xlApp.Cells(8,9)).MergeCells = true; //合并单元格
		objSheet.Cells(8,1).value="医生环节";
		objSheet.Cells(8,1).Interior.Pattern = 2;  //设置单元格背景样式*(1-无，2-细网格，3-粗网格，4-斑点，5-横线，6-竖线..)
		objSheet.Cells(9,1).value="是否选中";
		objSheet.Cells(9,2).value="代码";
		xlApp.Range(xlApp.Cells(9,3),xlApp.Cells(9,6)).MergeCells = true;  //合并单元格
		objSheet.Cells(9,3).value="描述";
		objSheet.Cells(9,7).value="应当是";
		objSheet.Cells(9,8).value="错误是";
		objSheet.Cells(9,9).value="其他";
		
		Doclen=DocList.length-1;
		for(var k=1;k<=Doclen;k++){
			var MULIDoArr=DocList[k].split("^");
			objSheet.Cells(9+k,1).value=MULIDoArr[0]; //是否选中
			objSheet.Cells(9+k,2).value=MULIDoArr[2]; //代码
			xlApp.Range(xlApp.Cells(9+k,3),xlApp.Cells(9+k,6)).MergeCells = true;  //合并单元格
			objSheet.Cells(9+k,3).value=MULIDoArr[3]; //描述
			objSheet.Cells(9+k,7).value=MULIDoArr[5]; //应当是
			objSheet.Cells(9+k,7).WrapText=true;  
			objSheet.Cells(9+k,8).value=MULIDoArr[6]; //错误是
			objSheet.Cells(9+k,8).WrapText=true;  
			objSheet.Cells(9+k,9).value=MULIDoArr[7]; //其他
		}
		
		//药师环节		
		xlApp.Range(xlApp.Cells(10+Doclen+3,1),xlApp.Cells(10+Doclen+3,9)).MergeCells = true;
		objSheet.Cells(10+Doclen+3,1).value="药师环节";
		objSheet.Cells(10+Doclen+3,1).Interior.Pattern = 2; 
		objSheet.Cells(10+Doclen+4,1).value="是否选中";
		objSheet.Cells(10+Doclen+4,2).value="代码";
		xlApp.Range(xlApp.Cells(10+Doclen+4,3),xlApp.Cells(10+Doclen+4,6)).MergeCells = true;
		objSheet.Cells(10+Doclen+4,3).value="描述";
		objSheet.Cells(10+Doclen+4,7).value="应当是";
		objSheet.Cells(10+Doclen+4,8).value="错误是";
		objSheet.Cells(10+Doclen+4,9).value="其他";
		
		Apolen=ApoList.length-1;
		for(var k=1;k<=Apolen;k++){
			var MULIApArr=ApoList[k].split("^");
			objSheet.Cells(10+Doclen+4+k,1).value=MULIApArr[0]; //是否选中
			objSheet.Cells(10+Doclen+4+k,2).value=MULIApArr[2]; //代码
			xlApp.Range(xlApp.Cells(10+Doclen+4+k,3),xlApp.Cells(10+Doclen+4+k,6)).MergeCells = true;
			objSheet.Cells(10+Doclen+4+k,3).value=MULIApArr[3]; //描述
			objSheet.Cells(10+Doclen+4+k,7).value=MULIApArr[5]; //应当是
			objSheet.Cells(10+Doclen+4+k,7).WrapText=true;  
			objSheet.Cells(10+Doclen+4+k,8).value=MULIApArr[6]; //错误是
			objSheet.Cells(10+Doclen+4+k,8).WrapText=true;  
			objSheet.Cells(10+Doclen+4+k,9).value=MULIApArr[7]; //其他
		}
		DAlen=Doclen+Apolen;
		
		//配送环节		
		xlApp.Range(xlApp.Cells(10+DAlen+8,1),xlApp.Cells(10+DAlen+8,9)).MergeCells = true;
		objSheet.Cells(10+DAlen+8,1).value="配送环节";
		objSheet.Cells(10+DAlen+8,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DAlen+9,1).value="是否选中";
		objSheet.Cells(10+DAlen+9,2).value="代码";
		xlApp.Range(xlApp.Cells(10+DAlen+9,3),xlApp.Cells(10+DAlen+9,6)).MergeCells = true;
		objSheet.Cells(10+DAlen+9,3).value="描述";
		objSheet.Cells(10+DAlen+9,7).value="应当是";
		objSheet.Cells(10+DAlen+9,8).value="错误是";
		objSheet.Cells(10+DAlen+9,9).value="其他";

		Displen=DispList.length-1;
		for(var k=1;k<=Displen;k++){
			var MULIDiArr=DispList[k].split("^");
			objSheet.Cells(10+DAlen+9+k,1).value=MULIDiArr[0]; //是否选中
			objSheet.Cells(10+DAlen+9+k,2).value=MULIDiArr[2]; //代码
			xlApp.Range(xlApp.Cells(10+DAlen+9+k,3),xlApp.Cells(10+DAlen+9+k,6)).MergeCells = true;
			objSheet.Cells(10+DAlen+9+k,3).value=MULIDiArr[3]; //描述
			objSheet.Cells(10+DAlen+9+k,7).value=MULIDiArr[5]; //应当是
			objSheet.Cells(10+DAlen+9+k,7).WrapText=true;  
			objSheet.Cells(10+DAlen+9+k,8).value=MULIDiArr[6]; //错误是
			objSheet.Cells(10+DAlen+9+k,8).WrapText=true;  
			objSheet.Cells(10+DAlen+9+k,9).value=MULIDiArr[7]; //其他
		}
		DADilen=DAlen+Displen;
		
		//护士环节		
		xlApp.Range(xlApp.Cells(10+DADilen+11,1),xlApp.Cells(10+DADilen+11,9)).MergeCells = true;
		objSheet.Cells(10+DADilen+11,1).value="护士环节";
		objSheet.Cells(10+DADilen+11,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DADilen+12,1).value="是否选中";
		objSheet.Cells(10+DADilen+12,2).value="代码";
		xlApp.Range(xlApp.Cells(10+DADilen+12,3),xlApp.Cells(10+DADilen+12,6)).MergeCells = true;
		objSheet.Cells(10+DADilen+12,3).value="描述";
		objSheet.Cells(10+DADilen+12,7).value="应当是";
		objSheet.Cells(10+DADilen+12,8).value="错误是";
		objSheet.Cells(10+DADilen+12,9).value="其他";

		Nuslen=NurList.length-1;
		for(var k=1;k<=Nuslen;k++){
			var MULINuArr=NurList[k].split("^");
			objSheet.Cells(10+DADilen+12+k,1).value=MULINuArr[0]; //是否选中
			objSheet.Cells(10+DADilen+12+k,2).value=MULINuArr[2]; //代码
			xlApp.Range(xlApp.Cells(10+DADilen+12+k,3),xlApp.Cells(10+DADilen+12+k,6)).MergeCells = true;
			objSheet.Cells(10+DADilen+12+k,3).value=MULINuArr[3]; //描述
			objSheet.Cells(10+DADilen+12+k,7).value=MULINuArr[5]; //应当是
			objSheet.Cells(10+DADilen+12+k,7).WrapText=true;  
			objSheet.Cells(10+DADilen+12+k,8).value=MULINuArr[6]; //错误是
			objSheet.Cells(10+DADilen+12+k,8).WrapText=true;  
			objSheet.Cells(10+DADilen+12+k,9).value=MULINuArr[7]; //其他
		}
		DADiNulen=DADilen+Nuslen;
		
		//患者环节		
		xlApp.Range(xlApp.Cells(10+DADiNulen+16,1),xlApp.Cells(10+DADiNulen+16,9)).MergeCells = true;
		objSheet.Cells(10+DADiNulen+16,1).value="患者环节";
		objSheet.Cells(10+DADiNulen+16,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DADiNulen+17,1).value="是否选中";
		objSheet.Cells(10+DADiNulen+17,2).value="代码";
		xlApp.Range(xlApp.Cells(10+DADiNulen+17,3),xlApp.Cells(10+DADiNulen+17,6)).MergeCells = true;
		objSheet.Cells(10+DADiNulen+17,3).value="描述";
		objSheet.Cells(10+DADiNulen+17,7).value="应当是";
		objSheet.Cells(10+DADiNulen+17,8).value="错误是";
		objSheet.Cells(10+DADiNulen+17,9).value="其他";

		var Patlen=PatList.length-1;
		for(var k=1;k<=Patlen;k++){
			var MULIPaArr=PatList[k].split("^");
			objSheet.Cells(10+DADiNulen+17+k,1).value=MULIPaArr[0]; //是否选中
			objSheet.Cells(10+DADiNulen+17+k,2).value=MULIPaArr[2]; //代码
			xlApp.Range(xlApp.Cells(10+DADiNulen+17+k,3),xlApp.Cells(10+DADiNulen+17+k,6)).MergeCells = true;
			objSheet.Cells(10+DADiNulen+17+k,3).value=MULIPaArr[3]; //描述
			objSheet.Cells(10+DADiNulen+17+k,7).value=MULIPaArr[5]; //应当是
			objSheet.Cells(10+DADiNulen+17+k,7).WrapText=true;  
			objSheet.Cells(10+DADiNulen+17+k,8).value=MULIPaArr[6]; //错误是
			objSheet.Cells(10+DADiNulen+17+k,8).WrapText=true;  
			objSheet.Cells(10+DADiNulen+17+k,9).value=MULIPaArr[7]; //其他
		}
		DADiNuPalen=DADiNulen+Patlen;
		
		//当事医生、药师、护士信息
		var MedsRepLinkList=retvalArr[21];  
		var RepLinkList=MedsRepLinkList.split("&");
		for (i=0;i<RepLinkList.length;i++){
			var messList=RepLinkList[i].split("^");
			var medsrMes=""
			if (messList[4]=="DocL"){
				xlApp.Range(xlApp.Cells(10+Doclen+1,1),xlApp.Cells(10+Doclen+1,2)).MergeCells = true;
				objSheet.Cells(10+Doclen+1,1).value="当事医生信息：";
				xlApp.Range(xlApp.Cells(10+Doclen+1,3),xlApp.Cells(10+Doclen+1,9)).MergeCells = true;
				if(messList[1]==10){
					medsrMes="正式医生";
				}else if(messList[1]==11){
					medsrMes="研究生";
				}else if(messList[1]==12){
					medsrMes="进修医生";
				}
				objSheet.Cells(10+Doclen+1,3).value=medsrMes+" "+messList[2]+" "+messList[3];  //当事医生信息
			}else if(messList[4]=="ApoL"){
				xlApp.Range(xlApp.Cells(10+DAlen+6,1),xlApp.Cells(10+DAlen+6,2)).MergeCells = true;
				objSheet.Cells(10+DAlen+6,1).value="当事药师信息：";
				xlApp.Range(xlApp.Cells(10+DAlen+6,3),xlApp.Cells(10+DAlen+6,9)).MergeCells = true;
				if(messList[1]==20){
					medsrMes="正式药师";
				}else if(messList[1]==21){
					medsrMes="实习生";
				}else if(messList[1]==22){
					medsrMes="进修药师";
				}
				objSheet.Cells(10+DAlen+6,3).value=medsrMes+" "+messList[2]+" "+messList[3]; //当事药师信息
			}else if(messList[4]=="NurL"){
				xlApp.Range(xlApp.Cells(10+DADiNulen+14,1),xlApp.Cells(10+DADiNulen+14,2)).MergeCells = true;
				objSheet.Cells(10+DADiNulen+14,1).value="当事护士信息：";
				xlApp.Range(xlApp.Cells(10+DADiNulen+14,3),xlApp.Cells(10+DADiNulen+14,9)).MergeCells = true;
				objSheet.Cells(10+DADiNulen+14,3).value=retvalArr[27]+" "+retvalArr[28]+" "+retvalArr[29]; //当事护士信息
				if(messList[1]==30){
					medsrMes="正式护士";
				}else if(messList[1]==31){
					medsrMes="实习生";
				}else if(messList[1]==32){
					medsrMes="进修护士";
				}
				objSheet.Cells(10+DADiNulen+14,3).value=medsrMes+" "+messList[2]+" "+messList[3]; //当事护士信息
			}
		}
		
		xlApp.Range(8+":"+(10+DADiNuPalen+18)).HorizontalAlignment = 2; 
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+19,1),xlApp.Cells(10+DADiNuPalen+19,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Size = 16; //设置为16号字
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Name = "宋体"; 
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Bold = true; //设置为粗体
		objSheet.Cells(10+DADiNuPalen+19,1).value="后果："; 
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+20,1),xlApp.Cells(10+DADiNuPalen+20,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+20,1).value=retvalArr[23]+retvalArr[24]; //后果
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+21,1),xlApp.Cells(10+DADiNuPalen+21,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Size = 16; //设置为16号字
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Name = "宋体"; 
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Bold = true; //设置为粗体
		objSheet.Cells(10+DADiNuPalen+21,1).value="即时行动/干预："; 
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+22,1),xlApp.Cells(10+DADiNuPalen+27,9)).MergeCells = true;
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+22,1),xlApp.Cells(10+DADiNuPalen+27,9)).WrapText=true; //自动换行
		objSheet.Cells(10+DADiNuPalen+22,1).value=retvalArr[14];  //即时行动、干预
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,1),xlApp.Cells(10+DADiNuPalen+28,4)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,1).value="报告科室："+retvalArr[1];
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,6),xlApp.Cells(10+DADiNuPalen+28,7)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,6).value="报告人姓名："+retvalArr[15];
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,8),xlApp.Cells(10+DADiNuPalen+28,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,8).value="报告人职称："+retvalArr[16]; //报告人职称
		
		objSheet.printout();
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(typecode=="blood"){
		var retval=tkMakeServerCall("web.DHCADVBLDREPORT","getBldRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		}
		var retvalArr=retval.split("&&");
		//1、获取XLS打印路径
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_BloodReport.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		
		objSheet.Cells(2,2).value=retvalArr[3]; //报告编码
		objSheet.Cells(2,6).value=retvalArr[4]+" "+retvalArr[5]; //报告日期
		objSheet.Cells(3,2).value=retvalArr[6]; //病区
		objSheet.Cells(3,6).value=retvalArr[1]; //科室
		
		objSheet.Cells(5,1).Interior.Pattern = 2; 
		objSheet.Cells(6,2).value=retvalArr[9]; //病人ID
		objSheet.Cells(6,5).value=retvalArr[8]; //病人病案号
		objSheet.Cells(7,2).value=retvalArr[10]; //病人姓名
		objSheet.Cells(7,5).value=retvalArr[11]; //病人性别
		objSheet.Cells(7,8).value=retvalArr[12]; //病人年龄
		objSheet.Cells(8,2).value=retvalArr[13]; //出生日期
		objSheet.Cells(8,5).value=retvalArr[14]; //身份证号
	    objSheet.Cells(9,3).value=retvalArr[51]; //病床诊断/手术名称
		
		objSheet.Cells(10,8).value=retvalArr[15]; //孕产史
		objSheet.Cells(10,2).value=retvalArr[16]; //继往输血史
		objSheet.Cells(10,5).value=retvalArr[17]; //输血反应史
		objSheet.Cells(11,3).value=retvalArr[18]; //输血前血型检查结果
		objSheet.Cells(11,5).value=retvalArr[19]; //阴阳性
		objSheet.Cells(11,8).value=retvalArr[20]; //意外抗体筛查（阴阳性）
		objSheet.Cells(12,3).value=retvalArr[21]; //本次输注的血液信息
		objSheet.Cells(12,5).value=retvalArr[22]; //阴阳性
		objSheet.Cells(13,2).value=retvalArr[23]; //输注血量
		objSheet.Cells(14,1).Interior.Pattern = 2; 
		var bldrptBldType=retvalArr[50];  //患者体征
		var BldTypeArr=bldrptBldType.split("&");
		var BldTypelen=BldTypeArr.length;
		for(var k=0;k<BldTypelen;k++){
			var BldType=BldTypeArr[k].split("^");
			objSheet.Cells(16+k,1).value=BldType[1]; //输血类别
			xlApp.Range(xlApp.Cells(15+k,2),xlApp.Cells(15+k,3)).MergeCells = true;
			objSheet.Cells(16+k,2).value=BldType[3]; //输血编号1
			objSheet.Cells(16+k,4).value=BldType[4]; //输血编号2
			objSheet.Cells(16+k,5).value=BldType[5]; //输血编号3
			xlApp.Range(xlApp.Cells(16+k,6),xlApp.Cells(16+k,7)).MergeCells = true;
			objSheet.Cells(16+k,6).value=BldType[6]; //输血编号1
		}
		
		xlApp.Range(xlApp.Cells(16+BldTypelen,1),xlApp.Cells(16+BldTypelen,8)).MergeCells = true;
		objSheet.Cells(16+BldTypelen,1).value="输血不良反应描述";
		objSheet.Cells(16+BldTypelen,1).Font.Size = 12; //设置为12号字
		objSheet.Cells(16+BldTypelen,1).Font.Name = "宋体"; 
		objSheet.Cells(16+BldTypelen,1).Font.Bold = true; //设置为粗体
		objSheet.Cells(16+BldTypelen,1).Interior.Pattern = 2; 
		xlApp.Range(xlApp.Cells(17+BldTypelen,1),xlApp.Cells(17+BldTypelen,4)).MergeCells = true;
		xlApp.Range(xlApp.Cells(17+BldTypelen,5),xlApp.Cells(17+BldTypelen,8)).MergeCells = true;
		objSheet.Cells(17+BldTypelen,1).value="患者体征";
		objSheet.Cells(17+BldTypelen,5).value="临床症状";
		
		
		var bldrptBldBasA=retvalArr[48];  //患者体征
		var BldBasArr=bldrptBldBasA.split("&");
		var BldBasAlen=BldBasArr.length;
		var BBasAlen=Math.ceil(BldBasAlen/2);
		for(var k=0;k<BBasAlen;k++){
			var BldB=BldBasArr[k].split("^");
			xlApp.Range(xlApp.Cells(18+BldTypelen+k,1),xlApp.Cells(18+BldTypelen+k,2)).MergeCells = true;
			objSheet.Cells(18+BldTypelen+k,1).value=BldB[0]+" "+BldB[1]; //是否选中
 			var i=BBasAlen+k;
 			if(i<BldBasAlen){
				var BldBi=BldBasArr[i].split("^");
				xlApp.Range(xlApp.Cells(18+BldTypelen+k,3),xlApp.Cells(18+BldTypelen+k,4)).MergeCells = true;
				objSheet.Cells(18+BldTypelen+k,3).value=BldBi[0]+" "+BldBi[1]; //描述
			}
		}
		var bldrptBldBasB=retvalArr[49];  //临床症状
		var BldBasBArr=bldrptBldBasB.split("&");
		var BldBasBlen=BldBasBArr.length;
		var BBasBlen=Math.ceil(BldBasBlen/2) ;
		for(var k=0;k<BBasBlen;k++){
			var BldB=BldBasBArr[k].split("^");
			xlApp.Range(xlApp.Cells(18+BldTypelen+k,5),xlApp.Cells(18+BldTypelen+k,6)).MergeCells = true;
			objSheet.Cells(18+BldTypelen+k,5).value=BldB[0]+" "+BldB[1]; //是否选中
 			var j=BBasBlen+k;
 			if(j<BldBasBlen){
				var BldBj=BldBasBArr[j].split("^");
				xlApp.Range(xlApp.Cells(18+BldTypelen+k,7),xlApp.Cells(18+BldTypelen+k,8)).MergeCells = true;
				objSheet.Cells(18+BldTypelen+k,7).value=BldBj[0]+" "+BldBj[1]; //描述
			}
		}
		if(BBasAlen>BBasBlen){
			BBasBlen=BBasAlen;
		}
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen,1),xlApp.Cells(18+BldTypelen+BBasBlen,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Size = 12; //设置为12号字
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Name = "宋体"; 
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Bold = true; //设置为粗体
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Interior.Pattern = 2; 
		objSheet.Cells(18+BldTypelen+BBasBlen,1).value="基本生命体征"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,1).value="体温："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,2).value=retvalArr[24]; //体温
		objSheet.Cells(18+BldTypelen+BBasBlen+1,3).value="血压："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,4).value=retvalArr[25]; //血压
		objSheet.Cells(18+BldTypelen+BBasBlen+1,5).value="脉搏："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,6).value=retvalArr[26]; //脉搏
		objSheet.Cells(18+BldTypelen+BBasBlen+1,7).value="呼吸频次："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,8).value=retvalArr[27]; //呼吸频次
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+2,1),xlApp.Cells(18+BldTypelen+BBasBlen+2,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+2,1).value="输血前预防用药："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+2,3),xlApp.Cells(18+BldTypelen+BBasBlen+2,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+2,3).value=retvalArr[28]+" "+retvalArr[29];  //输血前预防用药
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,1),xlApp.Cells(18+BldTypelen+BBasBlen+3,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,1).value="本次输血开始时间："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,3),xlApp.Cells(18+BldTypelen+BBasBlen+3,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,3).value=retvalArr[30]+" "+retvalArr[31]; //本次输血开始时间
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,6),xlApp.Cells(18+BldTypelen+BBasBlen+3,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,6).value="操作者工号："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+3,8).value=retvalArr[32]; //操作者工号
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,1),xlApp.Cells(18+BldTypelen+BBasBlen+4,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,1).value="输血反应发现时间："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,3),xlApp.Cells(18+BldTypelen+BBasBlen+4,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,3).value=retvalArr[33]+" "+retvalArr[34]; //输血反应发现时间
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,6),xlApp.Cells(18+BldTypelen+BBasBlen+4,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,6).value="发现者工号："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+4,8).value=retvalArr[35]; //发现者工号
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,1),xlApp.Cells(18+BldTypelen+BBasBlen+5,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,1).value="输血器厂家/批号："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,3),xlApp.Cells(18+BldTypelen+BBasBlen+5,5)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,3).value=retvalArr[36]; //输血器厂家/批号
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,6),xlApp.Cells(18+BldTypelen+BBasBlen+5,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,6).value="剩余血量(ml)："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+5,8).value=retvalArr[37]; //剩余血量
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,1),xlApp.Cells(18+BldTypelen+BBasBlen+6,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,1).value="严重程度："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,3),xlApp.Cells(18+BldTypelen+BBasBlen+6,5)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,3).value=retvalArr[39]; //严重程度
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,6),xlApp.Cells(18+BldTypelen+BBasBlen+6,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,6).value="相关性："; 
		objSheet.Cells(18+BldTypelen+BBasBlen+6,8).value=retvalArr[40]; //相关性
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+7,1),xlApp.Cells(18+BldTypelen+BBasBlen+7,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+7,1).value="输血不良反应拟诊："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+7,3),xlApp.Cells(18+BldTypelen+BBasBlen+7,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+7,3).value=retvalArr[38]; //输血不良反应拟诊
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+8,1),xlApp.Cells(18+BldTypelen+BBasBlen+8,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Size = 12; //设置为12号字
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Name = "宋体"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Bold = true; //设置为粗体
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Interior.Pattern = 2; 
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).value="临床处置："; 
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+9,1),xlApp.Cells(18+BldTypelen+BBasBlen+12,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+9,1).value=retvalArr[41]; //临床处置
		
		objSheet.Cells(18+BldTypelen+BBasBlen+13,1).value="患者转归："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+13,2),xlApp.Cells(18+BldTypelen+BBasBlen+13,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+13,2).value=retvalArr[42]+" "+retvalArr[43]+" "+retvalArr[44];  //患者转归
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+14,1),xlApp.Cells(18+BldTypelen+BBasBlen+14,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+14,1).value="与输血相关性："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+14,3),xlApp.Cells(18+BldTypelen+BBasBlen+14,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+14,3).value=retvalArr[45]; //与输血相关性
	
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+15,5),xlApp.Cells(18+BldTypelen+BBasBlen+15,6)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+15,5).value="报告人签名："; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+15,7),xlApp.Cells(18+BldTypelen+BBasBlen+15,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+15,7).value=retvalArr[2]; //填报人

		
		objSheet.printout();
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(typecode=="drug"){
		var retval=tkMakeServerCall("web.DHCADVMADRREPORT","getMadrRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1、获取XLS打印路径
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_DrugReport.xls";  //DHCST_PHCM_AdrReport  DHCADV_DrugReport
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		objSheet.Cells(2,2).value=retvalArr[0]; //报告状态
	
		objSheet.Cells(2,9).value=retvalArr[1]; //编号
		   
		objSheet.Cells(3,2).value=retvalArr[2]+" "+retvalArr[3]+""+retvalArr[4]; //类型
		objSheet.Cells(3,7).value=retvalArr[5]+retvalArr[6]; //报告单位类别

		objSheet.Cells(4,2).value=retvalArr[7]; //患者姓名
		objSheet.Cells(4,4).value=retvalArr[8]; //性别
		objSheet.Cells(4,6).value=retvalArr[9]; //出生日期
		objSheet.Cells(4,8).value=retvalArr[10]; //民族
		if(retvalArr[11]!=""){
		  objSheet.Cells(4,10).value=retvalArr[11]+" "+"Kg"; //体重
		}else{
		  objSheet.Cells(4,10).value=retvalArr[11]; //体重
		}
		objSheet.Cells(4,12).value=retvalArr[12]; //联系方式
		objSheet.Cells(5,2).value=retvalArr[13]; //原患疾病
		objSheet.Cells(5,5).value=retvalArr[14]; //医院名称
		objSheet.Cells(5,9).value=retvalArr[15]+retvalArr[16]; //既往药品不良反应/事件
		objSheet.Cells(6,5).value=retvalArr[17]; //病历号/门诊号
		objSheet.Cells(6,9).value=retvalArr[18]+retvalArr[19]; //家族药品不良反应/事件
		objSheet.Cells(7,2).value=retvalArr[20]+retvalArr[21]; //相关重要信息
		objSheet.Cells(8,3).value=retvalArr[22];  //不良反应/事件名称
		objSheet.Cells(8,10).value=retvalArr[23]+"  "+retvalArr[24]; //不良反应/事件发生时间
		objSheet.Cells(10,1).value=retvalArr[25]; //不良反应/事件过程描述
		objSheet.Cells(11,3).value=retvalArr[26]; //不良反应/事件的结果
		objSheet.Cells(11,7).value=retvalArr[27]; //表现/直接死因
		
		objSheet.Cells(11,11).value=retvalArr[28]+"  "+retvalArr[29]; //死亡时间
		objSheet.Cells(12,5).value=retvalArr[30]; //停药或减量后，反应/事件是否消失或减轻？
		objSheet.Cells(13,5).value=retvalArr[31]; //再次使用可疑药品后是否再次出现同样反应/事件
		objSheet.Cells(14,5).value=retvalArr[32]; //对原患疾病的影响

		objSheet.Cells(15,3).value=retvalArr[33]; //报告人评价
		objSheet.Cells(15,11).value=retvalArr[34]; //签名
		objSheet.Cells(16,3).value=retvalArr[35];  //报告单位评价
		objSheet.Cells(16,11).value=retvalArr[36]; //签名

		objSheet.Cells(17,3).value=retvalArr[37]; //联系电话
		objSheet.Cells(17,11).value=retvalArr[38]+retvalArr[39]; //职业
		objSheet.Cells(18,3).value=retvalArr[40]; //电子邮箱
		
		objSheet.Cells(18,6).value=retvalArr[41]; //签名
		objSheet.Cells(18,11).value=retvalArr[42]; //报告部门
		objSheet.Cells(19,3).value=retvalArr[43]; //单位名称
		objSheet.Cells(19,6).value=retvalArr[44]; //联系人
		objSheet.Cells(19,8).value=retvalArr[45]; //电话
		objSheet.Cells(19,11).value=retvalArr[46]+"  "+retvalArr[47]; //报告日期
		objSheet.Cells(20,2).value=retvalArr[48]; //备注
	   
	   xlApp.Range(objSheet.Cells(22,1),objSheet.Cells(22,12)).Interior.Pattern = 2; //药品列表标题背景颜色
	   	var advRepDrgItmList=retvalArr[49];  //药品列表

	   var advRepDrgItmArr=advRepDrgItmList.split("||");
	    for(var k=0;k<advRepDrgItmArr.length;k++){
		var drgItmArr=advRepDrgItmArr[k].split("^");
		objSheet.Cells(23+k,1).value=drgItmArr[0]; //类型
		objSheet.Cells(23+k,2).value="'"+drgItmArr[1]; //批准文号
		objSheet.Cells(23+k,3).value=drgItmArr[3]; //商品名称
		objSheet.Cells(23+k,4).value=drgItmArr[8]; //通用名
		objSheet.Cells(23+k,6).value=drgItmArr[5]; //厂家
		objSheet.Cells(23+k,7).value="'"+drgItmArr[17]; //批号
		objSheet.Cells(23+k,8).value="'"+drgItmArr[9]; //用法用量
		objSheet.Cells(23+k,9).value="'"+drgItmArr[13]; //开始时间
		objSheet.Cells(23+k,11).value="'"+drgItmArr[14]; //结束时间
		objSheet.Cells(23+k,12).value="'"+drgItmArr[16]; //用药原因
	}  
		objSheet.printout();
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(typecode=="med"||typecode=="bldevent"){
		var retval=tkMakeServerCall("web.DHCADVMEDADRREPORT","getMedRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("提示:","取数据错误！");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1、获取XLS打印路径
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MedAdrReport.xls";
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		objSheet.Cells(2,2).value=retvalArr[0]+" "+retvalArr[1]; //报告日期
		objSheet.Cells(2,7).value=retvalArr[2]; //报告编码

		objSheet.Cells(4,2).value=retvalArr[3]; //病人ID
		objSheet.Cells(4,5).value=retvalArr[4]; //病区
		objSheet.Cells(4,9).value=retvalArr[5]; //病案号
		objSheet.Cells(5,2).value=retvalArr[6]; //患者姓名
		objSheet.Cells(5,5).value=retvalArr[7]; //性别
		objSheet.Cells(5,8).value=retvalArr[8]; //年龄
		objSheet.Cells(6,2).value=retvalArr[9]; //临床诊断
		var adrAnonymFlag="" ,adrRepUser="" ,adradrRepDept="";
		if (retvalArr[10]==1){
			adrAnonymFlag="匿名";
			adrRepUser="" ;
			adradrRepDept="";
		 }else{
			 adrAnonymFlag=""
			 adrRepUser=retvalArr[11] ;
			 adradrRepDept=retvalArr[12];
			 
		 }
		
		objSheet.Cells(8,2).value=adrAnonymFlag; //匿名

		
		objSheet.Cells(8,7).value=adrRepUser; //报告人姓名
		objSheet.Cells(9,2).value=adradrRepDept; //报告部门
		objSheet.Cells(9,7).value=retvalArr[25]+" "+retvalArr[26]; //事件发生日期时间
		objSheet.Cells(10,3).value=retvalArr[15]; //上报人职业类别
		
		objSheet.Cells(10,8).value=retvalArr[16]; //上报人职称
		objSheet.Cells(11,2).value=retvalArr[17]; //联系电话
		objSheet.Cells(11,8).value=retvalArr[18]; //电子邮件
		objSheet.Cells(13,3).value=retvalArr[19]; //事件报告类型
		objSheet.Cells(13,7).value=retvalArr[20]+" "+retvalArr[21]; //事件发生地点
		//objSheet.Cells(13,9).value=retvalArr[21]; //地点其他
		objSheet.Cells(15,1).value=retvalArr[22]; //事件过程描述
	    objSheet.Cells(22,1).value=retvalArr[23];   //存在隐患
	    objSheet.Cells(28,1).value=retvalArr[24];   //改进建议

	   
		objSheet.printout();
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
} 
