///不良事件导出 
function ExportWordData(ID,RepTypeCode,RepType,filePath)
{ 
	var RepDate="",OccDateTime="",RepProcess=""
	runClassMethod("web.DHCADVCOMMONPRINT","GetExportbyWord",
	{AdvMasterDr:ID,RepTypeCode:RepTypeCode},function(ret){
		var tmp=ret.replace(/(^\s*)|(\s*$)/g,"").split("^");
		RepDate=tmp[0];
		OccDateTime=tmp[1];
		RepProcess=tmp[2];
						
	},"",false);
	/* var WordApp=new ActiveXObject("Word.Application"); 
	var wdCharacter=1 
	var wdOrientLandscape = 1 
	WordApp.Application.Visible=true; //执行完成之后是否弹出已经生成的word 
	var myDoc=WordApp.Documents.Add();//创建新的空文档
	
	//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//页面方向设置为横向 
	WordApp. Selection.ParagraphFormat.Alignment=1 //1居中对齐,0为居右
	WordApp. Selection.ParagraphFormat.BaseLineAlignment=4 //1居中对齐,0为居右  
	WordApp. Selection.Font.Bold=true 
	WordApp. Selection.Font.Size=16 
	WordApp. Selection.TypeText("护理不良事件改进报表（典型案例分析）"); 
	
	WordApp.Selection.TypeParagraph()     // 插入段落
	WordApp. Selection.Font.Bold=false 
	WordApp. Selection.Font.Size=10
	var myTable=myDoc.Tables.Add (WordApp.Selection.Range, 12,2) //12行2列的表格 
	myTable.Style="网格型"
	var title = "标题" 
	var TableRange; //以下为给表格中的单元格赋值 
	myTable.Rows.Height =30; //设置行高
	myTable.Rows(1).Cells.Merge();//合并整行
	myTable.Cell(1,1).width=420;
	myTable.Rows(2).Cells.Merge();//合并整行
	myTable.Cell(2,1).width=420;
	myTable.Cell(2,1).range.Font.Bold= false;
	myTable.Cell(2,1).range.Font.size= 12;
	myTable.Rows(3).Cells.Merge();//合并整行
	myTable.Cell(3,1).width=420;
	myTable.Cell(3,1).Height="50";
	
	myTable.Cell(1,1).range.Text="上报日期：   "+RepDate+"                   发生时间："+OccDateTime;
	myTable.Cell(2,1).range.Text="医疗机构名称： "+LgHospDesc+"                  不良事件类别： "+RepType;
	//myTable.Cell(n+2,2).Height="25";
	//WordApp. Selection.ParagraphFormat.Alignment=1 //1居中对齐,0为居右
	myTable.Cell(3,1).range.Text="事件过程（详细描述）："+RepProcess;
	myTable.Cell(3,1).Height="200";
	myTable.Rows(4).Cells.Merge();//合并整行
	//myTable.Rows(4).Alignment=1;//1居中对齐,0为居右
	myTable.Cell(4,1).range.Text="原因分析"
	myTable.Cell(4,1).width=420;
	myTable.Cell(5,1).width=140;
	myTable.Cell(5,1).range.Text="人（任何相关人员）";
	myTable.Cell(5,2).width=280;
	myTable.Cell(5,1).Height="50";
	
	myTable.Cell(6,1).width=140;
	myTable.Cell(6,1).range.Text="方法（环节、政策、指南规范）";
	myTable.Cell(6,2).width=280;
	myTable.Cell(6,1).Height="50";
	
	myTable.Cell(7,1).width=140;
	myTable.Cell(7,1).range.Text="材料（材料用品、耗材、形式、培训手册）";
	myTable.Cell(7,2).width=280;
	myTable.Cell(7,1).Height="50";
	
	myTable.Cell(8,1).width=140;
	myTable.Cell(8,1).range.Text="机器（技术、设备、系统）";
	myTable.Cell(8,2).width=280;
	myTable.Cell(8,1).Height="50";
	
	myTable.Cell(9,1).width=140;
	myTable.Cell(9,1).range.Text="环境（温度，湿度，噪声干扰，照明，净化污染）";
	myTable.Cell(9,2).width=280;
	myTable.Cell(9,1).Height="50";
	
	myTable.Cell(10,1).width=140;
	myTable.Cell(10,1).range.Text="其他";
	myTable.Cell(10,2).width=280;
	myTable.Cell(10,1).Height="50";
	
	myTable.Cell(11,1).width=140;
	myTable.Cell(11,1).range.Text="改进措施与方法：";
	myTable.Cell(11,2).width=280;
	myTable.Cell(11,1).Height="50";
	
	myTable.Cell(12,1).width=140;
	myTable.Cell(12,1).range.Text="评价：";
	myTable.Cell(12,2).width=280;
	myTable.Cell(12,1).Height="50";	
	
	myTable.range.ParagraphFormat.Alignment = 0; //向左对其
	row_count = 0; 
	col_count = 0 
	myDoc.Protect(1)  */
	
	//1、获取XLS导出路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_ExportWord.docx";
	
	
	var WordApp=new ActiveXObject("Word.Application");  
	WordApp.Application.Visible=true; //执行完成之后是否弹出已经生成的word 
	
	//var myDoc = WordApp.documents.open("E:\\技术文档\\word打印导出\\word打印测试\\bianshuai.docx");     //此处为打开已有的模版
	var myDoc = WordApp.documents.open(Template);     //此处为打开已有的模版
	var table=WordApp.ActiveDocument.Tables(1);	
	table.Cell(1,2).range.Text=RepDate;
	table.Cell(1,4).range.Text=OccDateTime;
	table.Cell(2,2).range.Text=LgHospDesc;
	table.Cell(2,4).range.Text=RepType;
	table.Cell(3,1).range.Text="事件过程（详细描述）："+RepProcess;
	myDoc.Protect(1) 
	RepType=RepType.replace("/","或");
	RepDate=RepDate.replace(/(\/)/g,"-");
	myDoc .saveAs(filePath+"北京安贞医院"+RepType+RepDate+".docx");     //存放到指定的位置注意路径一定要是“\\”不然会报错
}
			
		
///不良事件朝阳导出excel统计
function ExportExcelStatic(StDate,EndDate,filePath)
{ 
	var  retvalArr="",succflag="false"

	runClassMethod("web.DHCADVCOMMONPRINT","GetExportbyExcel",
	{StDate:StDate,EndDate:EndDate},function(ret){
				
		retvalArr=ret.replace(/(^\s*)|(\s*$)/g,"").split("^");
	},"",false);
	if(retvalArr==""){
		$.messager.alert("提示:","取数据错误！");
		return;
	}	
	//1、获取XLS导出路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_ExportStatic.xls";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	objSheet.Cells(2,5).value=LgHospDesc; //医院名称
	objSheet.Cells(8,1).value=retvalArr[0]; //总数
	objSheet.Cells(8,2).value=retvalArr[1]; //痊愈
	objSheet.Cells(8,3).value=retvalArr[2]; //好转
	objSheet.Cells(8,4).value=retvalArr[3]; //未发展
	objSheet.Cells(8,5).value=retvalArr[4]; //发展
	objSheet.Cells(8,6).value=retvalArr[5]; //Ⅰ
	objSheet.Cells(8,7).value=retvalArr[6]; //Ⅱ
	objSheet.Cells(8,8).value=retvalArr[7]; //Ⅲ
	objSheet.Cells(8,9).value=retvalArr[8]; //Ⅳ
	objSheet.Cells(8,10).value=retvalArr[9]; //Ⅴ
	objSheet.Cells(8,11).value=retvalArr[10]; //Ⅵ
	objSheet.Cells(8,12).value=retvalArr[11]; //院外带入
	objSheet.Cells(8,13).value=retvalArr[12]; //胃管
	objSheet.Cells(8,14).value=retvalArr[13]; //尿管
	objSheet.Cells(8,15).value=retvalArr[14]; //深静脉
	objSheet.Cells(8,16).value=retvalArr[15]; //其他
	objSheet.Cells(8,17).value=retvalArr[16]; //跌倒
	objSheet.Cells(8,18).value=retvalArr[17]; //坠床
	objSheet.Cells(8,19).value=retvalArr[18]; //给错患者
	objSheet.Cells(8,20).value=retvalArr[19]; //时间
	objSheet.Cells(8,21).value=retvalArr[20]; //剂量
	objSheet.Cells(8,22).value=retvalArr[21]; //其他
	objSheet.Cells(8,23).value=retvalArr[22]; //走失
	objSheet.Cells(8,24).value=retvalArr[23]; //自杀
	objSheet.Cells(8,25).value=retvalArr[24]; //烫伤
	objSheet.Cells(8,26).value=retvalArr[25]; //其他
	objSheet.Cells(8,27).value=retvalArr[26]; //医疗相关
	objSheet.Cells(8,28).value=retvalArr[27]; //药事相关
	objSheet.Cells(8,29).value=retvalArr[28]; //护理相关
	objSheet.Cells(8,30).value=retvalArr[29]; //其他

	objSheet.Cells(13,5).value=LgUserName; //上报人
	objSheet.Cells(13,16).value="64456715"; //联系电话
	objSheet.Cells(13,24).value=formatDate(0); //上报时间
	succflag=xlBook.SaveAs(filePath+"北京市朝阳区医疗机构护理安全（不良）事件报表"+".xls");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}

///不良事件医管局导出excel统计
function ExportExcelAllData(StDate,EndDate,RepType,filePath)
{ 
	var  retvalArr="",succflag="false"

	runClassMethod("web.DHCADVCOMMONPRINT","GetExpbyExcel",
	{StDate:StDate,EndDate:EndDate,reporttype:RepType},function(ret){
				
		retvalArr=ret;
	},"json",false);
	RepType=RepType.replace("/","或");
	StDate=StDate.replace(/(\/)/g,"-");
	EndDate=EndDate.replace(/(\/)/g,"-");
	var NameList=RepType+StDate+"至"+EndDate;
	if(retvalArr==""){
		$.messager.alert("提示:","取数据错误！");
		return false;
	}		
		//意外事件报告单
		if(RepType=="意外事件报告单"){  
			succflag=exportAccidentData(retvalArr,filePath,NameList); //
		}
		//用药错误报告单
		if(RepType=="用药错误报告单"){ 
			succflag=exportDrugErrData(retvalArr,filePath,NameList);
		}
		//跌倒(坠床)事件报告单	
		if(RepType=="跌倒(坠床)事件报告单"){  
			succflag=exportFallDownData(retvalArr,filePath,NameList);
		}
		//管路脱落报告单
		if(RepType=="管路滑脱报告单"){  
			succflag=exportPipeOffData(retvalArr,filePath,NameList);
		}
		//压疮报告单
		if(RepType=="压疮报告单"){  
			succflag=exportSkinUlcerData(retvalArr,filePath,NameList);
		}	
	return succflag;
}
//ygj 意外事件报告单导出
function exportAccidentData(data,filePath,NameList){
	var succflag="false";
	//var data=DataList.split("$$")
	var strjLen=data.length;
	//1、获取XLS导出路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_AccidentFillexcel.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	for (i=0;i<strjLen;i++)
  	{
		objSheet.Cells(2+i,1).value=$g(data[i]["RepHospType"]); //填报单位
		objSheet.Cells(2+i,2).value="'"+"003903110105210111"; //机构登记号
		objSheet.Cells(2+i,3).value="'"+$g(data[i]["DeptLocOne"]); //填报科室1		
		objSheet.Cells(2+i,4).value="'"+$g(data[i]["DeptLocTwo"]); //填报科室2
		objSheet.Cells(2+i,5).value="'"+$g(data[i]["ReportDate"]); //报告日期	
		objSheet.Cells(2+i,6).value=$g(data[i]["DisMedThingPatName"]); //患者姓名
		objSheet.Cells(2+i,7).value=$g(data[i]["PatMedicalNo"]); //病案号	
		objSheet.Cells(2+i,8).value=$g(data[i]["OccuLoc"]); //发生科室		
		objSheet.Cells(2+i,9).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data[i]); //患者来源
		objSheet.Cells(2+i,10).value=$g(data[i]["PatSexinput"]); //性别
		objSheet.Cells(2+i,11).value=$g(data[i]["PatAge"]); //年龄
		objSheet.Cells(2+i,12).value="'"+radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data[i]); //文化程度
		objSheet.Cells(2+i,13).value="'"+$g(data[i]["PatDiag"]); //第一诊断		
		objSheet.Cells(2+i,14).value="'"+$g(data[i]["PatAdmDate"]); //入院日期  
		objSheet.Cells(2+i,15).value="'"+$g(data[i]["PatAdmADLScore"]); //入院时ADL得分
		objSheet.Cells(2+i,16).value="'"+radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data[i]); //护理级别
		objSheet.Cells(2+i,17).value="'"+radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data[i]); //患者自我照顾能力
		objSheet.Cells(2+i,18).value="'"+radioValue("AFType-94495,AFType-94498,AFType-94499",data[i]); //意外事件发生类型
		objSheet.Cells(2+i,19).value=""; //意外事件类型其他
		var oth=radioValue("AFType-94500,AFType-94927,AFType-94978,AFType-94979,AFType-94980,AFType-94981,AFType-94165",data[i]);
		if(oth!=""){
			objSheet.Cells(2+i,18).value="'"+"其他"
			objSheet.Cells(2+i,19).value="'"+oth;
		}
		objSheet.Cells(2+i,20).value="'"+$g(data[i]["HappenTime"])+" "+$g(data[i]["OccurTime"]).split(":")[0]+"时"; //给药发生日期
		objSheet.Cells(2+i,21).value="'"+radioValue("HappenPlace-label-94575,HappenPlace-label-94576,HappenPlace-label-94577,HappenPlace-label-94579,HappenPlace-label-94580,HappenPlace-label-94581,HappenPlace-label-94582,HappenPlace-label-94583,HappenPlace-label-94584,HappenPlace-label-94585",data[i]); //发生地点
		objSheet.Cells(2+i,22).value="'"+radioValue("PatEscort-94349,PatEscort-94350",data[i]); //陪护人员		
		objSheet.Cells(2+i,23).value="'"+radioValue("DiscoverMan-94528,DiscoverMan-94530,DiscoverMan-94531,DiscoverMan-94532",data[i]); //发现人
		objSheet.Cells(2+i,24).value="'"+radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-94470,PipeDutyNurTitle-94471",data[i]); //事件发生当班护士职称
		objSheet.Cells(2+i,25).value=""; //工作年限
		if($g(data[i]["WLManWorkLife"])!=""){
			objSheet.Cells(2+i,25).value="'"+$g(data[i]["WLManWorkLife"])+"年"; //工作年限
		}	
		objSheet.Cells(2+i,26).value="'"+radioValue("AFResult-94565",data[i]); //事件造成的后果
		objSheet.Cells(2+i,27).value="'"+$g(data[i]["AFResult-94567"]); //事件造成的后果		
		if($g(data[i]["AFResult-94567"])!=""){
			objSheet.Cells(2+i,26).value="其他"
		}
		objSheet.Cells(2+i,28).value="'"+$g(data[i]["WLEventProcess"]); //事件经过
	}
	succflag=xlBook.SaveAs(filePath+NameList+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}
//ygj 用药错误报告单
function exportDrugErrData(data,filePath,NameList)
{
	var succflag="false";
	//var data=DataList.split("$$")
	var strjLen=data.length;
	//1、获取XLS导出路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_DrugUseErrexcel.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	for (i=0;i<strjLen;i++)
	{
		objSheet.Cells(2+i,1).value=$g(data[i]["RepHospType"]); //填报单位
		objSheet.Cells(2+i,2).value="'"+"003903110105210111"; //机构登记号
		objSheet.Cells(2+i,3).value="'"+$g(data[i]["ReportDate"]); //报告日期
		objSheet.Cells(2+i,4).value="'"+$g(data[i]["DeptLocOne"]); //填报科室1		
		objSheet.Cells(2+i,5).value="'"+$g(data[i]["DeptLocTwo"]); //填报科室2
			
		objSheet.Cells(2+i,6).value=$g(data[i]["DisMedThingPatName"]); //患者姓名
		objSheet.Cells(2+i,7).value=$g(data[i]["PatMedicalNo"]); //病案号	
		objSheet.Cells(2+i,8).value=$g(data[i]["OccuLoc"]); //发生科室		
		objSheet.Cells(2+i,9).value=$g(data[i]["PatSexinput"]); //性别
		objSheet.Cells(2+i,10).value=$g(data[i]["PatAge"]); //年龄
		objSheet.Cells(2+i,11).value="'"+radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data[i]); //患者来源
		objSheet.Cells(2+i,12).value="'"+radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data[i]); //文化程度
		objSheet.Cells(2+i,13).value="'"+$g(data[i]["PatDiag"]); //第一诊断		
		objSheet.Cells(2+i,14).value="'"+$g(data[i]["PatAdmDate"]); //入院日期
		objSheet.Cells(2+i,15).value="'"+radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data[i]); //护理级别
		
		objSheet.Cells(2+i,16).value="'"+$g(data[i]["GiveDrugHappenTime"]); //给药发生日期
		if($g(data[i]["OccurTime"])!=""){
			objSheet.Cells(2+i,16).value="'"+$g(data[i]["GiveDrugHappenTime"])+" "+$g(data["OccurTime"]).split(":")[0]+"时"; //给药发生日期
		}
			
		objSheet.Cells(2+i,17).value="'"+radioValue("DrugUsePartyTitle-94597,DrugUsePartyTitle-94599,DrugUsePartyTitle-94611,DrugUsePartyTitle-94612",data[i]); //当事人职称
		objSheet.Cells(2+i,18).value=""; //当事人工作年限
		if($g(data[i]["DrugUsePartyWorkYears"])!=""){
			objSheet.Cells(2+i,25).value="'"+$g(data[i]["DrugUsePartyWorkYears"])+"年"; //当事人工作年限
		}
		objSheet.Cells(2+i,19).value=$g(data[i]["Shift"]);  //班次
		objSheet.Cells(2+i,20).value="'"+radioValue("DrugUseHappenPlace-label-94587,DrugUseHappenPlace-label-94588,DrugUseHappenPlace-label-94589,DrugUseHappenPlace-label-94590",data[i]); //发生地点
		objSheet.Cells(2+i,21).value="'"+""; //发生地点 其他
		if($g(data[i]["DrugUseHappenPlace-label-94591"])!=""){
			objSheet.Cells(2+i,20).value="'"+"其他"
			objSheet.Cells(2+i,21).value="'"+$g(data[i]["DrugUseHappenPlace-label-94591"])
		}
		objSheet.Cells(2+i,22).value="'"+$g(data[i]["DrugUseErrType-94616"]); //给药对象错误	
		objSheet.Cells(2+i,23).value="'"+$g(data[i]["DrugUseErrType-94617"]); //给药时间错误
		objSheet.Cells(2+i,24).value="'"+$g(data[i]["DrugUseErrType-94618"]); //给药途径错误
		objSheet.Cells(2+i,25).value="'"+$g(data[i]["DrugUseErrType-94619"]); //遗漏给药	
		objSheet.Cells(2+i,26).value="'"+$g(data[i]["DrugUseErrType-94620"]); //输液速度错误
		objSheet.Cells(2+i,27).value="'"+$g(data[i]["DrugUseErrType-94621"]); //剂量错误		
		objSheet.Cells(2+i,28).value="'"+$g(data[i]["DrugUseErrType-94622"]); //剂型错误
		objSheet.Cells(2+i,29).value="'"+$g(data[i]["DrugUseErrType-94623"]); //药物错误
		objSheet.Cells(2+i,30).value="'"+$g(data[i]["DrugUseErrType-94624"]); //药物效期错误
		objSheet.Cells(2+i,31).value="'"+$g(data[i]["DrugUseErrType-94625"]); //其他
		objSheet.Cells(2+i,32).value="'"+""; // 其他 描述
		if($g(data[i]["DrugUseErrType-94625"])!=""){
			objSheet.Cells(2+i,31).value="'"+"其他"
			objSheet.Cells(2+i,32).value="'"+$g(data[i]["DrugUseErrType-94625"])
		}
		objSheet.Cells(2+i,33).value="'"+radioValue("DrugUseDefectResult-label-94633,DrugUseDefectResult-label-94634,DrugUseDefectResult-label-94635,DrugUseDefectResult-label-94636,DrugUseDefectResult-label-94637",data[i]); //缺陷引起的后果
		objSheet.Cells(2+i,34).value="'"+""; // 缺陷引起的后果其他
		if($g(data[i]["DrugUseDefectResult-label-94638"])!=""){
			objSheet.Cells(2+i,33).value="'"+"其他"
			objSheet.Cells(2+i,34).value="'"+$g(data[i]["DrugUseDefectResult-label-94638"])
		}
		objSheet.Cells(2+i,35).value="'"+$g(data[i]["WLEventProcess"]); // 事件经过
		
	}
	
	succflag=xlBook.SaveAs(filePath+NameList+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}

//ygj 跌倒(坠床)事件报告单
function exportFallDownData(data,filePath,NameList)
{
	var succflag="false";
	//var data=DataList.split("$$")
	var strjLen=data.length;
	//1、获取XLS导出路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_FallDownFillexcel.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	for (i=0;i<strjLen;i++)
	{
		objSheet.Cells(2+i,1).value=$g(data[i]["RepHospType"]); //填报单位
		objSheet.Cells(2+i,2).value="'"+"003903110105210111"; //机构登记号
		objSheet.Cells(2+i,3).value="'"+$g(data[i]["ReportDate"]); //报告日期
		objSheet.Cells(2+i,4).value="'"+$g(data[i]["DeptLocOne"]); //填报科室1		
		objSheet.Cells(2+i,5).value="'"+$g(data[i]["DeptLocTwo"]); //填报科室2
			
		objSheet.Cells(2+i,6).value=$g(data[i]["DisMedThingPatName"]); //患者姓名
		objSheet.Cells(2+i,7).value=$g(data[i]["PatMedicalNo"]); //病案号	
		objSheet.Cells(2+i,8).value=$g(data[i]["OccuLoc"]); //发生科室		
		objSheet.Cells(2+i,9).value=$g(data[i]["PatSexinput"]); //性别
		objSheet.Cells(2+i,10).value=$g(data[i]["PatAge"]); //年龄
		objSheet.Cells(2+i,11).value="'"+radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data[i]); //患者来源
		objSheet.Cells(2+i,12).value="'"+$g(data[i]["PatDiag"]); //第一诊断
		
		objSheet.Cells(2+i,13).value="'"+$g(data[i]["PatAdmDate"]); //入院日期	
		objSheet.Cells(2+i,14).value="'"+$g(data[i]["PatAdmADLScore"]); //ADL得分
		objSheet.Cells(2+i,15).value="'"+radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data[i]); //护理级别
		objSheet.Cells(2+i,16).value=radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data[i]); //患者自我照顾能力
		objSheet.Cells(2+i,17).value="'"+$g(data[i]["HappenTime"]); //给药发生日期
		if($g(data[i]["OccurTime"])!=""){
			objSheet.Cells(2+i,17).value="'"+$g(data[i]["HappenTime"])+" "+$g(data[i]["OccurTime"]).split(":")[0]+"时"; //给药发生日期
		}
		objSheet.Cells(2+i,18).value="'"+radioValue("HappenPlace-label-94575,HappenPlace-label-94576,HappenPlace-label-94577,HappenPlace-label-94579,HappenPlace-label-94580,HappenPlace-label-94581,HappenPlace-label-94582,HappenPlace-label-94583,HappenPlace-label-94584",data[i]); //发生地点
		objSheet.Cells(2+i,19).value="'"+""; //发生地点 其他
		if($g(data[i]["HappenPlace-label-94585"])!=""){
			objSheet.Cells(2+i,18).value="'"+"其他"
			objSheet.Cells(2+i,19).value="'"+$g(data[i]["HappenPlace-label-94585"])
		}
		objSheet.Cells(2+i,20).value="'"+radioValue("PatEscort-94349,PatEscort-94350",data[i]); //陪护人员	
		
		objSheet.Cells(2+i,21).value="'"+($g(data[i]["OccurReason-95068"])==""?"":"是"); //患者因素
		objSheet.Cells(2+i,22).value="'"+($g(data[i]["OccurReason-95068-95072"])==""?"":"是"); //意识障碍	
		objSheet.Cells(2+i,23).value="'"+($g(data[i]["OccurReason-95068-95073"])==""?"":"是"); //视力听力、障碍
		objSheet.Cells(2+i,24).value="'"+($g(data[i]["OccurReason-95068-95074"])==""?"":"是"); //活动障碍
		objSheet.Cells(2+i,25).value="'"+($g(data[i]["OccurReason-95068-95085"])==""?"":"是"); //有跌倒史	
		objSheet.Cells(2+i,26).value="'"+($g(data[i]["OccurReason-95068-95088"])==""?"":"是"); //疾病
		objSheet.Cells(2+i,27).value="'"+""; //其他		
		objSheet.Cells(2+i,28).value="'"+""; //其他患者因素
		if($g(data[i]["OccurReason-95068-95089"])!=""){
			objSheet.Cells(2+i,27).value="'"+"是"
			objSheet.Cells(2+i,28).value="'"+$g(data[i]["OccurReason-95068-95089"])
		}
		objSheet.Cells(2+i,29).value="'"+($g(data[i]["OccurReason-95069"])==""?"":"是"); //药物因素
		objSheet.Cells(2+i,30).value="'"+($g(data[i]["OccurReason-95069-95094"])==""?"":"是"); //散瞳剂	
		objSheet.Cells(2+i,31).value="'"+($g(data[i]["OccurReason-95069-95095"])==""?"":"是"); //镇静安眠剂
		objSheet.Cells(2+i,32).value="'"+($g(data[i]["OccurReason-95069-95098"])==""?"":"是"); //降压利尿剂
		objSheet.Cells(2+i,33).value="'"+($g(data[i]["OccurReason-95069-95099"])==""?"":"是"); //降糖剂	
		objSheet.Cells(2+i,34).value="'"+($g(data[i]["OccurReason-95069-95102"])==""?"":"是"); //镇挛抗癫剂
		objSheet.Cells(2+i,35).value="'"+($g(data[i]["OccurReason-95069-95103"])==""?"":"是"); //麻醉止痛剂	
		objSheet.Cells(2+i,36).value="'"+($g(data[i]["OccurReason-95069-95104"])==""?"":"是"); //泻药
		objSheet.Cells(2+i,37).value="'"+""; //其他		
		objSheet.Cells(2+i,38).value="'"+""; //其他药物因素
		if($g(data[i]["OccurReason-95069-95105"])!=""){
			objSheet.Cells(2+i,37).value="'"+"是"
			objSheet.Cells(2+i,38).value="'"+$g(data[i]["OccurReason-95069-95105"])
		}
		objSheet.Cells(2+i,39).value="'"+($g(data[i]["OccurReason-95070"])==""?"":"是"); //管理因素
		objSheet.Cells(2+i,40).value="'"+($g(data[i]["OccurReason-95070-95106"])==""?"":"是"); //环境因素	
		objSheet.Cells(2+i,41).value="'"+($g(data[i]["OccurReason-95070-95112"])==""?"":"是"); //设备设施缺陷或故障
		objSheet.Cells(2+i,42).value="'"+($g(data[i]["OccurReason-95070-95113"])==""?"":"是"); //宣教不到位
		objSheet.Cells(2+i,43).value="'"+($g(data[i]["OccurReason-95070-95114"])==""?"":"是"); //管理不到位	
		objSheet.Cells(2+i,44).value="'"+($g(data[i]["OccurReason-95070-95121"])==""?"":"是"); //培训不到位
		objSheet.Cells(2+i,45).value="'"+""; //其他		
		objSheet.Cells(2+i,46).value="'"+""; //其他管理因素
		if($g(data[i]["OccurReason-95070-95122"])!=""){
			objSheet.Cells(2+i,45).value="'"+"是"
			objSheet.Cells(2+i,46).value="'"+$g(data[i]["OccurReason-95070-95122"]);
		}
		objSheet.Cells(2+i,47).value="'"+$g(data[i]["OccurReason-95071"]); //其他因素	
									
		objSheet.Cells(2+i,48).value="'"+radioValue("DiscoverMan-94528,DiscoverMan-94530,DiscoverMan-94531",data[i]); //发现人
		objSheet.Cells(2+i,49).value="'"+""; //发现人其他
		if($g(data[i]["DiscoverMan-94532"])!=""){
			objSheet.Cells(2+i,48).value="'"+"其他"
			objSheet.Cells(2+i,49).value="'"+$g(data[i]["DiscoverMan-94532"]);
		}
		objSheet.Cells(2+i,50).value="'"+radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-94470,PipeDutyNurTitle-94471",data[i]); //事件发生当班护士职称
		objSheet.Cells(2+i,51).value=""; //工作年限
		if($g(data[i]["WLManWorkLife"])!=""){
			objSheet.Cells(2+i,51).value="'"+$g(data[i]["WLManWorkLife"])+"年"; //工作年限
		}
		objSheet.Cells(2+i,52).value="'"+radioValue("FDPatState-95051,FDPatState-95052,FDPatState-95053,FDPatState-95054,FDPatState-95055,FDPatState-95056,FDPatState-95057,FDPatState-95058,FDPatState-95059,FDPatState-95060,FDPatState-95061",data[i]); //跌倒/跌落（指患者身体的任何部位，不包括双脚，意外触及地面）时患者的状态	
		objSheet.Cells(2+i,53).value="'"+""; //状态其他
		if($g(data[i]["FDPatState-95062"])!=""){
			objSheet.Cells(2+i,52).value="'"+"其他"
			objSheet.Cells(2+i,53).value="'"+$g(data[i]["FDPatState-95062"]);
		}
		
		objSheet.Cells(2+i,54).value="'"+$g(data[i]["JuredPart"]); //受伤部位		
		objSheet.Cells(2+i,55).value="'"+radioValue("FDResult-95131,FDResult-95134",data[i]); //造成后果  
		objSheet.Cells(2+i,56).value="'"+""; //造成后果其他
		if($g(data[i]["FDResult-94245"])!=""){
			objSheet.Cells(2+i,55).value="'"+"其他"
			objSheet.Cells(2+i,56).value="'"+$g(data[i]["FDResult-94245"]);
		}
		objSheet.Cells(2+i,57).value="'"+$g(data[i]["WLEventProcess"]); //事件经过
		
	}
	
	succflag=xlBook.SaveAs(filePath+NameList+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}
//ygj 管路滑脱报告单
function exportPipeOffData(data,filePath,NameList)
{
	var succflag="false";
	//var data=DataList.split("$$")
	var strjLen=data.length;
	//1、获取XLS导出路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_PipeOffexcel.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	for (i=0;i<strjLen;i++)
	{
		objSheet.Cells(2+i,1).value=$g(data[i]["RepHospType"]); //填报单位
		objSheet.Cells(2+i,2).value="'"+"003903110105210111"; //机构登记号
		objSheet.Cells(2+i,3).value="'"+$g(data[i]["ReportDate"]); //报告日期
		objSheet.Cells(2+i,4).value="'"+$g(data[i]["DeptLocOne"]); //填报科室1		
		objSheet.Cells(2+i,5).value="'"+$g(data[i]["DeptLocTwo"]); //填报科室2
			
		objSheet.Cells(2+i,6).value=$g(data[i]["DisMedThingPatName"]); //患者姓名
		objSheet.Cells(2+i,7).value=$g(data[i]["PatMedicalNo"]); //病案号	
		objSheet.Cells(2+i,8).value=$g(data[i]["OccuLoc"]); //发生科室		
		objSheet.Cells(2+i,9).value=$g(data[i]["PatSexinput"]); //性别
		objSheet.Cells(2+i,10).value=$g(data[i]["PatAge"]); //年龄
		objSheet.Cells(2+i,11).value="'"+radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data[i]); //患者来源
		objSheet.Cells(2+i,12).value="'"+radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data[i]); //文化程度
		objSheet.Cells(2+i,13).value="'"+$g(data[i]["PatDiag"]); //第一诊断
		
		objSheet.Cells(2+i,14).value="'"+$g(data[i]["PatAdmDate"]); //入院日期	
		objSheet.Cells(2+i,15).value="'"+$g(data[i]["PatAdmADLScore"]); //ADL得分
		objSheet.Cells(2+i,16).value="'"+radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data[i]); //护理级别
		objSheet.Cells(2+i,17).value=radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data[i]); //患者自我照顾能力
		
		objSheet.Cells(2+i,18).value="'"+($g(data[i]["PipeType-94449"])==""?"":"是"); //胃管
		objSheet.Cells(2+i,19).value="'"+($g(data[i]["PipeType-94450"])==""?"":"是"); //尿管	
		objSheet.Cells(2+i,20).value="'"+($g(data[i]["PipeType-94451"])==""?"":"是"); //透析管路
		objSheet.Cells(2+i,21).value="'"+($g(data[i]["PipeType-94452"])==""?"":"是"); //气管插管
		objSheet.Cells(2+i,22).value="'"+($g(data[i]["PipeType-94453"])==""?"":"是"); //气管切开套管	
		objSheet.Cells(2+i,23).value="'"+($g(data[i]["PipeType-94454"])==""?"":"是"); //鼻饲管
		objSheet.Cells(2+i,24).value="'"+($g(data[i]["PipeType-94455"])==""?"":"是"); //动脉置管
		objSheet.Cells(2+i,25).value="'"+($g(data[i]["PipeType-94456"])==""?"":"是"); //深静脉置管	
		objSheet.Cells(2+i,26).value="'"+($g(data[i]["PipeType-94457"])==""?"":"是"); //PICC
		objSheet.Cells(2+i,27).value="'"+($g(data[i]["PipeType-94458"])==""?"":"是"); //胸腔闭式引流管
		objSheet.Cells(2+i,28).value="'"+($g(data[i]["PipeType-94459"])==""?"":"是"); //腹腔引流管
		objSheet.Cells(2+i,29).value="'"+($g(data[i]["PipeType-94460"])==""?"":"是"); //伤口引流管	
		objSheet.Cells(2+i,30).value="'"+($g(data[i]["PipeType-94461"])==""?"":"是"); //心包引流管
		objSheet.Cells(2+i,31).value="'"+($g(data[i]["PipeType-94462"])==""?"":"是"); //脑室引流管
		objSheet.Cells(2+i,32).value="'"+""; //其它	
		objSheet.Cells(2+i,33).value="'"+""; //其它描述		
		if($g(data[i]["PipeType-94463"])!=""){
			objSheet.Cells(2+i,32).value="'"+"是"
			objSheet.Cells(2+i,33).value="'"+$g(data[i]["PipeType-94463"])
		}
		
		objSheet.Cells(2+i,34).value="'"+$g(data[i]["PipeFindDate"]); //脱管发生时间
		if($g(data[i]["OccurTime"])!=""){
			objSheet.Cells(2+i,17).value="'"+$g(data[i]["PipeFindDate"])+" "+$g(data[i]["OccurTime"]).split(":")[0]+"时"; //脱管发生时间
		}
		
		objSheet.Cells(2+i,35).value="'"+$g(data[i]["TubeDate"]); //置管日期	
		objSheet.Cells(2+i,36).value="'"+radioValue("PipeDiscoverers-94464,PipeDiscoverers-94465,PipeDiscoverers-94466",data[i]); //发现人
		objSheet.Cells(2+i,37).value="'"+""; //发现人其他人员
		if($g(data[i]["PipeDiscoverers-94467"])!=""){
			objSheet.Cells(2+i,36).value="'"+"其他"
			objSheet.Cells(2+i,37).value="'"+$g(data[i]["PipeDiscoverers-94467"]);
		}
		objSheet.Cells(2+i,38).value="'"+radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-9446870,PipeDutyNurTitle-94471",data[i]); //事件发生当班护士职称
		
		objSheet.Cells(2+i,39).value="'"+$g(data[i]["WallWorkYears"]); //工作年限
		if($g(data[i]["WallWorkYears"])!=""){
			objSheet.Cells(2+i,51).value="'"+$g(data[i]["WallWorkYears"])+"年"; //工作年限
		}
		objSheet.Cells(2+i,40).value="'"+radioValue("PipePS-94473-94476,PipePS-94473-94477,PipePS-94473-94478,PipePS-94473-94479,PipePS-94473-94480",data[i]); //意识状态	
		objSheet.Cells(2+i,41).value="'"+radioValue("PipePS-94474-94481,PipePS-94474-94482,PipePS-94474-94483,PipePS-94474-94484",data[i]); //精神状态
		if($g(data[i]["PipePS-94474-94485"])!=""){
			objSheet.Cells(2+i,40).value="'"+"其他";
		}
		objSheet.Cells(2+i,42).value="'"+radioValue("PipePS-94475-94486,PipePS-94475-94487,PipePS-94475-94488,PipePS-94475-94489",data[i]); //活动能力
		objSheet.Cells(2+i,43).value="'"+$g(data[i]["PipePS-94475-94490"]); //其他活动能力
		if($g(data[i]["PipePS-94475-94490"])!=""){
			objSheet.Cells(2+i,42).value="'"+"其它";
			objSheet.Cells(2+i,43).value="'"+$g(data[i]["PipePS-94475-94490"]);
		}
		
		objSheet.Cells(2+i,44).value="'"+radioValue("PipeReason-94493,PipeReason-94494,PipeReason-94496",data[i]); //脱管原因
		objSheet.Cells(2+i,45).value="'"+""; //脱管原因其它	
		if($g(data[i]["PipeReason-94497"])!=""){
			objSheet.Cells(2+i,44).value="'"+"其它";
			objSheet.Cells(2+i,45).value="'"+$g(data[i]["PipeReason-94497"]);
		}
			
		objSheet.Cells(2+i,46).value="'"+radioValue("PipeFixedMethod-94503,PipeFixedMethod-94506,PipeFixedMethod-94507,PipeFixedMethod-94508",data[i]); //固定方法
		objSheet.Cells(2+i,47).value="'"+""; //固定方法其它	
		if($g(data[i]["PipeFixedMethod-94509"])!=""){
			objSheet.Cells(2+i,46).value="'"+"其它";
			objSheet.Cells(2+i,47).value="'"+$g(data[i]["PipeFixedMethod-94509"]);
		}
									
		objSheet.Cells(2+i,48).value="'"+radioValue("PipeOther-94512-94518,PipeOther-94512-94519",data[i]); //健康教育
		objSheet.Cells(2+i,49).value="'"+radioValue("PipeOther-94513-94520,PipeOther-94513-94521",data[i]); //约束带使用
		
		objSheet.Cells(2+i,50).value="'"+radioValue("PipeOther-94515-94522,PipeOther-94515-94523",data[i]); //事件发生前患者是否使用镇静药物
		
		objSheet.Cells(2+i,51).value="'"+radioValue("PatEscort-94349,PatEscort-94350",data[i]); //陪护人员
		objSheet.Cells(2+i,52).value="'"+radioValue("PipeOther-94516-94524,PipeOther-94516-94525",data[i]); //管路滑脱时工作人员
		objSheet.Cells(2+i,53).value="'"+radioValue("PipeOther-94517-94526,PipeOther-94517-94527",data[i]); //患者既往是否发生过管路滑脱事件	

		objSheet.Cells(2+i,54).value="'"+radioValue("PipeComplication-94539,PipeComplication-94540",data[i]); //并发症
		objSheet.Cells(2+i,55).value="'"+""; //出血	
		objSheet.Cells(2+i,56).value="'"+""; //出血Ml
		if($g(data[i]["PipeComplication-94540-94541"])!=""){
			objSheet.Cells(2+i,55).value="'"+"是"
			objSheet.Cells(2+i,56).value="'"+$g(data[i]["PipeComplication-94540-94541"])
		}
		objSheet.Cells(2+i,57).value="'"+($g(data[i]["PipeComplication-94540-94542"])==""?"":"是"); //气栓
		objSheet.Cells(2+i,58).value="'"+($g(data[i]["PipeComplication-94540-94543"])==""?"":"是"); //血栓
		objSheet.Cells(2+i,59).value="'"+($g(data[i]["PipeComplication-94540-94544"])==""?"":"是"); //窒息	
		objSheet.Cells(2+i,60).value="'"+($g(data[i]["PipeComplication-94540-94545"])==""?"":"是"); //感染
		objSheet.Cells(2+i,61).value="'"+($g(data[i]["PipeComplication-94540-94546"])==""?"":"是"); //气胸
		objSheet.Cells(2+i,62).value="'"+($g(data[i]["PipeComplication-94540-94547"])==""?"":"是"); //吻合口瘘
		objSheet.Cells(2+i,63).value="'"+""; //其它	
		objSheet.Cells(2+i,64).value="'"+""; //其它并发症		
		if($g(data[i]["PipeComplication-94540-94548"])!=""){
			objSheet.Cells(2+i,63).value="'"+"是"
			objSheet.Cells(2+i,64).value="'"+$g(data[i]["PipeComplication-94540-94547"])
		}
		
		objSheet.Cells(2+i,65).value="'"+($g(data[i]["PipeTakeSteps-94533"])==""?"":"是"); //重新置管  
		objSheet.Cells(2+i,66).value="'"+($g(data[i]["PipeTakeSteps-94534"])==""?"":"是"); //脱管部位处理
		objSheet.Cells(2+i,67).value="'"+($g(data[i]["PipeTakeSteps-94536"])==""?"":"是"); //诊断性检查
		objSheet.Cells(2+i,68).value="'"+""; //其它
		objSheet.Cells(2+i,69).value="'"+""; //其它措施
		if($g(data[i]["PipeTakeSteps-94537"])!=""){
			objSheet.Cells(2+i,68).value="'"+"是"
			objSheet.Cells(2+i,69).value="'"+$g(data[i]["PipeTakeSteps-94537"]);
		}
		objSheet.Cells(2+i,70).value="'"+$g(data[i]["WLEventProcess"]); //事件经过
		
	}
	
	succflag=xlBook.SaveAs(filePath+NameList+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}

//ygj 压疮报告单
function exportSkinUlcerData(data,filePath,NameList)
{
	var succflag="false";
	//var data=DataList.split("$$")
	var strjLen=data.length;
	//1、获取XLS导出路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_SkinUlcerexcel.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	for (i=0;i<strjLen;i++)
	{
		objSheet.Cells(3+i,1).value=$g(data[i]["RepHospType"]); //填报单位
		objSheet.Cells(3+i,2).value="'"+"003903110105210111"; //机构登记号
		objSheet.Cells(3+i,3).value="'"+$g(data[i]["ReportDate"]); //报告日期
		objSheet.Cells(3+i,4).value="'"+$g(data[i]["DeptLocOne"]); //填报科室1		
		objSheet.Cells(3+i,5).value="'"+$g(data[i]["DeptLocTwo"]); //填报科室2
			
		objSheet.Cells(3+i,6).value=$g(data[i]["DisMedThingPatName"]); //患者姓名
		objSheet.Cells(3+i,7).value=$g(data[i]["PatMedicalNo"]); //病案号	
		objSheet.Cells(3+i,8).value=$g(data[i]["OccuLoc"]); //发生科室		
		objSheet.Cells(3+i,9).value=$g(data[i]["PatSexinput"]); //性别
		objSheet.Cells(3+i,10).value=$g(data[i]["PatAge"]); //年龄
		objSheet.Cells(3+i,11).value="'"+radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data[i]); //患者来源
		
		objSheet.Cells(3+i,12).value="'"+$g(data[i]["PatDiag"]).split(",")[0]; //第一诊断
		
		objSheet.Cells(3+i,13).value="'"+$g(data[i]["PatAdmDate"]); //入院日期	
		objSheet.Cells(3+i,14).value="'"+$g(data[i]["PatAdmADLScore"]); //ADL得分
		objSheet.Cells(3+i,15).value="'"+radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data[i]); //护理级别
		objSheet.Cells(3+i,16).value="'"+radioValue("UseUlcerRiskpointtab-94929,UseUlcerRiskpointtab-94930,UseUlcerRiskpointtab-94931",data[i]); //使用压疮风险评分表
		objSheet.Cells(3+i,17).value="'"+""; //其他_内容		
		if($g(data[i]["UseUlcerRiskpointtab-94932"])!=""){
			objSheet.Cells(3+i,16).value="'"+"其他"
			objSheet.Cells(3+i,17).value="'"+$g(data[i]["UseUlcerRiskpointtab-94932"])
		}
		objSheet.Cells(3+i,18).value=radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data[i]); //患者自我照顾能力
		objSheet.Cells(3+i,19).value="'"+$g(data[i]["OccurUlcerRiskScore"]); //压疮风险评分
		objSheet.Cells(3+i,20).value="'"+radioValue("OccurUlcerRiskLev-94943,OccurUlcerRiskLev-94944,OccurUlcerRiskLev-94945,OccurUlcerRiskLev-94946",data[i]); //风险等级		
		objSheet.Cells(3+i,21).value="'"+radioValue("PatEscort-94349,PatEscort-94340",data); //陪护人员
																														
		var UlcerPartlist=$g(data[i]["UlcerPart"]);//压疮部位
		var Ulcerlen=UlcerPartlist.length; //压疮部位个数
		if (Ulcerlen>4){
			Ulcerlen=4;
		}
		for(var k=0;k<Ulcerlen;k++){
		
			objSheet.Cells(3+i,22+32*k).value="'"+radioValue("UlcerPart-95158-95163-95170,UlcerPart-95158-95163-95171",UlcerPartlist[k]); //压疮来源	
			objSheet.Cells(3+i,23+32*k).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95162-95192"]); //压疮发现日期
			objSheet.Cells(3+i,24+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95172"])==""?"":"是"); //部位_枕部
			objSheet.Cells(3+i,25+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95178"])==""?"":"是"); //部位_骶尾部	
			objSheet.Cells(3+i,26+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173"])==""?"":"是"); //部位_耳廓
			objSheet.Cells(3+i,27+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173-95196"])==""?"":"是"); //耳廓_左
			objSheet.Cells(3+i,28+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173-95197"])==""?"":"是"); //耳廓_右
			objSheet.Cells(3+i,29+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179"])==""?"":"是"); //部位_膝部	
			objSheet.Cells(3+i,30+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179-94189"])==""?"":"是"); //膝部_左
			objSheet.Cells(3+i,31+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179-94190"])==""?"":"是"); //膝部_右
			objSheet.Cells(3+i,32+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174"])==""?"":"是"); //部位_肩胛部
			objSheet.Cells(3+i,33+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174-94173"])==""?"":"是"); //肩胛部_左
			objSheet.Cells(3+i,34+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174-94174"])==""?"":"是"); //肩胛部_右
			objSheet.Cells(3+i,35+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180"])==""?"":"是"); //部位_踝部
			objSheet.Cells(3+i,36+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180-94193"])==""?"":"是"); //踝部_左
			objSheet.Cells(3+i,37+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180-94194"])==""?"":"是"); //踝部_右
			objSheet.Cells(3+i,38+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175"])==""?"":"是"); //部位_肘部
			objSheet.Cells(3+i,39+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175-94177"])==""?"":"是"); //肘部_左
			objSheet.Cells(3+i,40+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175-94178"])==""?"":"是"); //肘部_右
			objSheet.Cells(3+i,41+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181"])==""?"":"是"); //部位_足跟部
			objSheet.Cells(3+i,42+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181-94197"])==""?"":"是"); //足跟部_左
			objSheet.Cells(3+i,43+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181-94198"])==""?"":"是"); //足跟部_右
			objSheet.Cells(3+i,44+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176"])==""?"":"是"); //部位_髂前上棘
			objSheet.Cells(3+i,45+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176-94181"])==""?"":"是"); //髂前上棘_左
			objSheet.Cells(3+i,46+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176-94182"])==""?"":"是"); //髂前上棘_右
			objSheet.Cells(3+i,47+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177"])==""?"":"是"); //部位_髋部
			objSheet.Cells(3+i,48+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177-94185"])==""?"":"是"); //髋部_左
			objSheet.Cells(3+i,49+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177-94186"])==""?"":"是"); //髋部_右
			objSheet.Cells(3+i,50+32*k).value="'"+""; //其他
			objSheet.Cells(3+i,51+32*k).value="'"+""; //其它_内容  	
			if($g(data[i]["UlcerPart-95158-95166-95182"])!=""){
				objSheet.Cells(3+i,50+32*k).value="'"+"是"
				objSheet.Cells(3+i,51+32*k).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95166-95182"])
			}
			objSheet.Cells(3+i,52+32*k).value="'"+radioValue("UlcerPart-95158-95169-95183,UlcerPart-95158-95169-95184,UlcerPart-95158-95169-95185,UlcerPart-95158-95169-95186,UlcerPart-95158-95169-95187,UlcerPart-95158-95169-95188",UlcerPartlist[k]); //压疮分期
			objSheet.Cells(3+i,53+32*k).value="'"+""; //压疮面积(cm*cm) 	
			if(($g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])!="")&&($g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"]))){
				objSheet.Cells(3+i,53+32*k).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])+"*"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"]);
			}

		}
		var Patreson=myRadioValue("UlcerOccurReason-94948-94952,UlcerOccurReason-94948-94953,UlcerOccurReason-94948-94954,UlcerOccurReason-94948-94955,UlcerOccurReason-94948-94956,UlcerOccurReason-94948-94957,UlcerOccurReason-94948-94958,UlcerOccurReason-94948-94959",data[i]);  //压疮发生原因 患者因素
		objSheet.Cells(3+i,150).value="'"+(Patreson==""?"":"是"); //患者因素	
		objSheet.Cells(3+i,151).value="'"+($g(data[i]["UlcerOccurReason-94948-94952"])==""?"":"是"); //卧床
		objSheet.Cells(3+i,152).value="'"+($g(data[i]["UlcerOccurReason-94948-94953"])==""?"":"是"); //制动
		objSheet.Cells(3+i,153).value="'"+($g(data[i]["UlcerOccurReason-94948-94954"])==""?"":"是"); //强迫体位	
		objSheet.Cells(3+i,154).value="'"+($g(data[i]["UlcerOccurReason-94948-94955"])==""?"":"是"); //肥胖
		objSheet.Cells(3+i,155).value="'"+($g(data[i]["UlcerOccurReason-94948-94956"])==""?"":"是"); //大小便失禁
		objSheet.Cells(3+i,156).value="'"+($g(data[i]["UlcerOccurReason-94948-94957"])==""?"":"是"); //浮肿
		objSheet.Cells(3+i,157).value="'"+($g(data[i]["UlcerOccurReason-94948-94958"])==""?"":"是"); //消瘦	
		objSheet.Cells(3+i,158).value="'"+""; //其他	
		objSheet.Cells(3+i,159).value="'"+""; //其他_内容		
		if($g(data[i]["UlcerOccurReason-94948-94959"])!=""){
			objSheet.Cells(3+i,158).value="'"+"是"
			objSheet.Cells(3+i,159).value="'"+$g(data[i]["UlcerOccurReason-94948-94959"])
		}
		
		var illnessreson=myRadioValue("UlcerOccurReason-94949-94960,UlcerOccurReason-94949-94961,UlcerOccurReason-94949-94962,UlcerOccurReason-94949-94963,UlcerOccurReason-94949-94964",data[i]);  //病情因素
		objSheet.Cells(3+i,160).value="'"+(illnessreson==""?"":"是"); //病情因素	
		objSheet.Cells(3+i,161).value="'"+($g(data[i]["UlcerOccurReason-94949-94960"])==""?"":"是"); //低蛋白血症
		objSheet.Cells(3+i,162).value="'"+($g(data[i]["UlcerOccurReason-94949-94961"])==""?"":"是"); //贫血
		objSheet.Cells(3+i,163).value="'"+($g(data[i]["UlcerOccurReason-94949-94962"])==""?"":"是"); //昏迷	
		objSheet.Cells(3+i,164).value="'"+($g(data[i]["UlcerOccurReason-94949-94963"])==""?"":"是"); //感觉受损
		objSheet.Cells(3+i,165).value="'"+""; //其他	
		objSheet.Cells(3+i,166).value="'"+""; //其他_内容		
		if($g(data[i]["UlcerOccurReason-94949-94964"])!=""){
			objSheet.Cells(3+i,165).value="'"+"是"
			objSheet.Cells(3+i,166).value="'"+$g(data[i]["UlcerOccurReason-94949-94964"])
		}
	
		var Nurreson=myRadioValue("UlcerOccurReason-94950-94966,UlcerOccurReason-94950-94967,UlcerOccurReason-94950-94968,UlcerOccurReason-94950-94969,UlcerOccurReason-94950-94970,UlcerOccurReason-94950-94971,UlcerOccurReason-94950-94972,UlcerOccurReason-94950-94973,UlcerOccurReason-94950-94974",data[i]);  //护理人员因素
		objSheet.Cells(3+i,167).value="'"+(Nurreson==""?"":"是"); //护理人员因素	
		objSheet.Cells(3+i,168).value="'"+($g(data[i]["UlcerOccurReason-94950-94966"])==""?"":"是"); //未按时翻身
		objSheet.Cells(3+i,169).value="'"+($g(data[i]["UlcerOccurReason-94950-94967"])==""?"":"是"); //未及时清洁、擦洗皮肤
		objSheet.Cells(3+i,170).value="'"+($g(data[i]["UlcerOccurReason-94950-94968"])==""?"":"是"); //床单潮湿、不洁、褶皱	
		objSheet.Cells(3+i,171).value="'"+($g(data[i]["UlcerOccurReason-94950-94969"])==""?"":"是"); //管路较长时间受压而未发现
		objSheet.Cells(3+i,172).value="'"+($g(data[i]["UlcerOccurReason-94950-94970"])==""?"":"是"); //管路固定不当
		objSheet.Cells(3+i,173).value="'"+($g(data[i]["UlcerOccurReason-94950-94971"])==""?"":"是"); //护理操作不当，拖、拉、扯、拽等
		objSheet.Cells(3+i,174).value="'"+($g(data[i]["UlcerOccurReason-94950-94972"])==""?"":"是"); //护理人员评估不当	
		objSheet.Cells(3+i,175).value="'"+($g(data[i]["UlcerOccurReason-94950-94973"])==""?"":"是"); //器具使用不当
		objSheet.Cells(3+i,176).value="'"+""; //其他	
		objSheet.Cells(3+i,177).value="'"+""; //其他_内容		
		if($g(data[i]["UlcerOccurReason-94950-94974"])!=""){
			objSheet.Cells(3+i,176).value="'"+"是"
			objSheet.Cells(3+i,177).value="'"+$g(data[i]["UlcerOccurReason-94950-94974"])
		}
		var othreason=myRadioValue("UlcerOccurReason-94951-94975,UlcerOccurReason-94951-94976",data[i])//压疮发生原因_其他因素
		objSheet.Cells(3+i,178).value="'"+(othreason==""?"":"是"); //压疮发生原因_其他因素	
		objSheet.Cells(3+i,179).value="'"+($g(data[i]["UlcerOccurReason-94951-94975"])==""?"":"是"); //护理人员配备不足
		objSheet.Cells(3+i,180).value="'"+""; //其他	
		objSheet.Cells(3+i,181).value="'"+""; //其他_内容		
		if($g(data[i]["UlcerOccurReason-94951-94975"])!=""){
			objSheet.Cells(3+i,180).value="'"+"是"
			objSheet.Cells(3+i,181).value="'"+$g(data[i]["UlcerOccurReason-94951-94975"])
		}
	
	
		objSheet.Cells(3+i,182).value="'"+($g(data[i]["AdoptNursMeasure-95006"])==""?"":"是"); //增加翻身频次
		objSheet.Cells(3+i,183).value="'"+($g(data[i]["AdoptNursMeasure-95007"])==""?"":"是"); //保持皮肤清洁
		objSheet.Cells(3+i,184).value="'"+($g(data[i]["AdoptNursMeasure-95008"])==""?"":"是"); //保持床单清洁干燥平整	
		objSheet.Cells(3+i,185).value="'"+($g(data[i]["AdoptNursMeasure-95009"])==""?"":"是"); //使用防压疮气垫
		objSheet.Cells(3+i,186).value="'"+($g(data[i]["AdoptNursMeasure-95010"])==""?"":"是"); //使用软垫垫于骨隆突部位
		objSheet.Cells(3+i,187).value="'"+($g(data[i]["AdoptNursMeasure-95011"])==""?"":"是"); //应用医疗仪器治疗创面
		objSheet.Cells(3+i,188).value="'"+($g(data[i]["AdoptNursMeasure-95012"])==""?"":"是"); //贴膜保护受压部位皮肤	
		objSheet.Cells(3+i,189).value="'"+($g(data[i]["AdoptNursMeasure-95013"])==""?"":"是"); //伤口换药	
		objSheet.Cells(3+i,190).value="'"+""; //其他	
		objSheet.Cells(3+i,191).value="'"+""; //其他_内容  
		if($g(data[i]["AdoptNursMeasure-95011"])!=""){
			objSheet.Cells(3+i,190).value="'"+"是"
			objSheet.Cells(3+i,191).value="'"+$g(data[i]["AdoptNursMeasure-95011"])
		}
		var UlcerOthlist="";
		for(var k=4;k<UlcerPartlist.length;k++){
			var orign=radioValue("UlcerPart-95158-95163-95170,UlcerPart-95158-95163-95171",UlcerPartlist[k]); //来源
			var orignout=radioValue("UlcerPart-95158-95163-95171-94233,UlcerPart-95158-95163-95171-94234,UlcerPart-95158-95163-95171-94235,UlcerPart-95158-95163-95171-94236",UlcerPartlist[k]); //院外带入
			if (orignout!=""){orign=orign+"（"+orignout+"）";}
			var part=""
			var qtpart=radioValue("UlcerPart-95158-95166-95172,UlcerPart-95158-95166-95178,UlcerPart-95158-95166-95182",UlcerPartlist[k]); //部位
			if (qtpart!=""){part=qtpart+"； "+part; }
			var ekpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173"]),"UlcerPart-95158-95166-95173-95196,UlcerPart-95158-95166-95173-95197",UlcerPartlist[k]); //耳廓
			if (ekpart!=""){part=ekpart+"； "+part; }
			var jjpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174"]),"UlcerPart-95158-95166-95174-94173,UlcerPart-95158-95166-95174-94174",UlcerPartlist[k]); //肩胛部
			if (jjpart!=""){part=jjpart+"； "+part; }
			var zbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175"]),"UlcerPart-95158-95166-95175-94177,UlcerPart-95158-95166-95175-94178",UlcerPartlist[k]); //肘部
			if (zbpart!=""){part=zbpart+"； "+part; }
			var qqsjpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176"]),"UlcerPart-95158-95166-95175-94177,UlcerPart-95158-95166-95175-94178",UlcerPartlist[k]); //髂前上棘
			if (qqsjpart!=""){part=qqsjpart+"； "+part; }
			var kbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177"]),"UlcerPart-95158-95166-95177-94185,UlcerPart-95158-95166-95177-94186",UlcerPartlist[k]); //髋部
			if (kbpart!=""){part=kbpart+"； "+part; }
			var xbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179"]),"UlcerPart-95158-95166-95179-94189,UlcerPart-95158-95166-95179-94190",UlcerPartlist[k]); //膝部
			if (xbpart!=""){part=xbpart+"； "+part; }
			var hbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180"]),"UlcerPart-95158-95166-95180-94193,UlcerPart-95158-95166-95180-94194",UlcerPartlist[k]); //踝部
			if (hbpart!=""){part=hbpart+"； "+part; }
			var zgbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181"]),"UlcerPart-95158-95166-95181-94197,UlcerPart-95158-95166-95181-94198",UlcerPartlist[k]); //足跟部
			if (zgbpart!=""){part=zgbpart+"； "+part; }
			if (UlcerOthlist=""){
				UlcerOthlist="部位"+(k+1)+"（发现日期："+$g(UlcerPartlist[k]["UlcerPart-95158-95162-95192"])+"来源："+orign+"部位："+part+"分期："+radioValue("UlcerPart-95158-95169-95183,UlcerPart-95158-95169-95184,UlcerPart-95158-95169-95185,UlcerPart-95158-95169-95186,UlcerPart-95158-95169-95187,UlcerPart-95158-95169-95188",UlcerPartlist[k])+"面积(长宽深 cm×cm×cm)："+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])+"×"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"])+"×"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94251"])+"）" ;
			}else{
				UlcerOthlist=UlcerOthlist+"；"+"部位"+(k+1)+"（发现日期："+$g(UlcerPartlist[k]["UlcerPart-95158-95162-95192"])+"来源："+orign+"部位："+part+"分期："+radioValue("UlcerPart-95158-95169-95183,UlcerPart-95158-95169-95184,UlcerPart-95158-95169-95185,UlcerPart-95158-95169-95186,UlcerPart-95158-95169-95187,UlcerPart-95158-95169-95188",UlcerPartlist[k])+"面积(长宽深 cm×cm×cm)："+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])+"×"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"])+"×"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94251"])+"）" ;
			}
		}
		objSheet.Cells(3+i,192).value="'"+$g(data[i]["WLEventProcess"])+UlcerOthlist; //事件经过(详细描述)	
		
	}
	
	succflag=xlBook.SaveAs(filePath+NameList+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}

//动态导出
function ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList)
{
	var data="",tabledata="";
	runClassMethod("web.DHCADVCOMMONPRINT","GetExportData",
	{StDate:StDate,EndDate:EndDate,reporttype:RepType,TitleList:TitleList,DescList:DescList},function(ret){
		data=ret;
	},"json",false);

	if((RepType.indexOf("压疮")>0)||(RepType.indexOf("压疮")==0)){
		runClassMethod("web.DHCADVCOMMONPRINT","GetExportData",
		{StDate:StDate,EndDate:EndDate,reporttype:RepType,TitleList:"UlcerPart",DescList:"压疮部位"},function(ret){
			tabledata=ret;
		},"json",false);
	}
	
	var succflag="false";
	var strjLen=data.length;
	var tbstrjLen=tabledata.length;
	//1、获取XLS导出路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_Export.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	var Title=TitleList.split("#");
	var titlelen=Title.length;
	
	var TbDesc=TabDescList.split("#");
	var tbdesclen=TbDesc.length;
	var TbTitle=TabFieldList.split("#");
	var tbtitlelen=TbTitle.length;
	var len=0;
	for (i=1;i<strjLen;i++)
  	{
		if(tbstrjLen==0){
			len=i-1;
		}
		for (j=0;j<titlelen;j++){
			xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,titlelen)).MergeCells = true;  //合并单元格
			objSheet.Cells(1,1).value="报告信息";
			objSheet.Cells(2,1+j).value="'"+$g(data[0][Title[titlelen-1-j]]); // 数据列描述
			objSheet.Cells(3+len,1+j).value="'"+$g(data[i][Title[titlelen-1-j]]); // 数据列 数据值
		}
	//}
		if(tbstrjLen>0) 
	  	{ 
			var UlcerPartlist=$g(tabledata[i]["UlcerPart"]);//压疮部位
			var Ulcerlen=UlcerPartlist.length; //压疮部位个数
	  	
			for (j=0;j<tbtitlelen;j++){ 
				xlApp.Range(xlApp.Cells(1,1+titlelen+0),xlApp.Cells(1,1+titlelen+29)).MergeCells = true;  //合并单元格
				objSheet.Cells(1,1+titlelen+0).value="部位";
				/* for(var k=0;k<Ulcerlen;k++){
					xlApp.Range(xlApp.Cells(1,1+titlelen+(k*(tbtitlelen-1))+k),xlApp.Cells(1,1+titlelen+((k+1)*(tbtitlelen-1))+k)).MergeCells = true;  //合并单元格
					objSheet.Cells(1,1+titlelen+(k*(tbtitlelen-1))+k).value="部位"+(k+1);
					objSheet.Cells(2,1+titlelen+(k*tbtitlelen)+j).value="'"+TbDesc[tbtitlelen-1-j]; //
					objSheet.Cells(2+i,1+titlelen+(k*tbtitlelen)+j).value="'"+$g(UlcerPartlist[k][TbTitle[tbtitlelen-1-j]]); //
				} */
				objSheet.Cells(2,1+titlelen+0).value="'"+"压疮来源";
				objSheet.Cells(2,1+titlelen+1).value="'"+"压疮发现日期";
				objSheet.Cells(2,1+titlelen+2).value="'"+"部位_枕部";
				objSheet.Cells(2,1+titlelen+3).value="'"+"部位_骶尾部";
				objSheet.Cells(2,1+titlelen+4).value="'"+"部位_耳廓_左";
				objSheet.Cells(2,1+titlelen+5).value="'"+"部位_耳廓_右";
				objSheet.Cells(2,1+titlelen+6).value="'"+"部位_膝部_左";
				objSheet.Cells(2,1+titlelen+7).value="'"+"部位_膝部_右";
				objSheet.Cells(2,1+titlelen+8).value="'"+"部位_肩胛部_左";
				objSheet.Cells(2,1+titlelen+9).value="'"+"部位_肩胛部_右";
				objSheet.Cells(2,1+titlelen+10).value="'"+"部位_踝部_左";
				objSheet.Cells(2,1+titlelen+11).value="'"+"部位_踝部_右";
				objSheet.Cells(2,1+titlelen+12).value="'"+"部位_肘部_左";
				objSheet.Cells(2,1+titlelen+13).value="'"+"部位_肘部_右";
				objSheet.Cells(2,1+titlelen+14).value="'"+"部位_足跟部_左";
				objSheet.Cells(2,1+titlelen+15).value="'"+"部位_足跟部_右";
				objSheet.Cells(2,1+titlelen+16).value="'"+"部位_髂前上棘_左";
				objSheet.Cells(2,1+titlelen+17).value="'"+"部位_髂前上棘_右";
				objSheet.Cells(2,1+titlelen+18).value="'"+"部位_髋部_左";
				objSheet.Cells(2,1+titlelen+19).value="'"+"部位_髋部_右";
				objSheet.Cells(2,1+titlelen+20).value="'"+"其它_内容";
				objSheet.Cells(2,1+titlelen+21).value="'"+"Ⅰ期";
				objSheet.Cells(2,1+titlelen+22).value="'"+"Ⅱ期";
				objSheet.Cells(2,1+titlelen+23).value="'"+"Ⅲ期";
				objSheet.Cells(2,1+titlelen+24).value="'"+"Ⅳ期";
				objSheet.Cells(2,1+titlelen+25).value="'"+"可疑深度组织损伤";
				objSheet.Cells(2,1+titlelen+26).value="'"+"难以分期";
				objSheet.Cells(2,1+titlelen+27).value="'"+"压疮面积长";
				objSheet.Cells(2,1+titlelen+28).value="'"+"压疮面积宽";
				objSheet.Cells(2,1+titlelen+29).value="'"+"压疮面积深";
				
				for(var k=0;k<Ulcerlen;k++){
					objSheet.Cells(3+len+k,1+titlelen+0).value="'"+radioValue("UlcerPart-95158-95163-95170,UlcerPart-95158-95163-95171",UlcerPartlist[k]); //压疮来源	
					objSheet.Cells(3+len+k,1+titlelen+1).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95162-95192"]); //压疮发现日期
					objSheet.Cells(3+len+k,1+titlelen+2).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95172"])==""?"0":"1"); //部位_枕部
					objSheet.Cells(3+len+k,1+titlelen+3).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95178"])==""?"0":"1"); //部位_骶尾部	
					objSheet.Cells(3+len+k,1+titlelen+4).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173-95196"])==""?"0":"1"); //耳廓_左
					objSheet.Cells(3+len+k,1+titlelen+5).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173-95197"])==""?"0":"1"); //耳廓_右
					objSheet.Cells(3+len+k,1+titlelen+6).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179-94189"])==""?"0":"1"); //膝部_左
					objSheet.Cells(3+len+k,1+titlelen+7).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179-94190"])==""?"0":"1"); //膝部_右
					objSheet.Cells(3+len+k,1+titlelen+8).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174-94173"])==""?"0":"1"); //肩胛部_左
					objSheet.Cells(3+len+k,1+titlelen+9).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174-94174"])==""?"0":"1"); //肩胛部_右
					objSheet.Cells(3+len+k,1+titlelen+10).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180-94193"])==""?"0":"1"); //踝部_左
					objSheet.Cells(3+len+k,1+titlelen+11).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180-94194"])==""?"0":"1"); //踝部_右
					objSheet.Cells(3+len+k,1+titlelen+12).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175-94177"])==""?"0":"1"); //肘部_左
					objSheet.Cells(3+len+k,1+titlelen+13).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175-94178"])==""?"0":"1"); //肘部_右
					objSheet.Cells(3+len+k,1+titlelen+14).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181-94197"])==""?"0":"1"); //足跟部_左
					objSheet.Cells(3+len+k,1+titlelen+15).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181-94198"])==""?"0":"1"); //足跟部_右
					objSheet.Cells(3+len+k,1+titlelen+16).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176-94181"])==""?"0":"1"); //髂前上棘_左
					objSheet.Cells(3+len+k,1+titlelen+17).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176-94182"])==""?"0":"1"); //髂前上棘_右
					objSheet.Cells(3+len+k,1+titlelen+18).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177-94185"])==""?"0":"1"); //髋部_左
					objSheet.Cells(3+len+k,1+titlelen+19).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177-94186"])==""?"0":"1"); //髋部_右
					objSheet.Cells(3+len+k,1+titlelen+20).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95166-95182"]); //其它_内容
					
					objSheet.Cells(3+len+k,1+titlelen+21).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95183"])==""?"0":"1"); //Ⅰ期
					objSheet.Cells(3+len+k,1+titlelen+22).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95184"])==""?"0":"1"); //Ⅱ期
					objSheet.Cells(3+len+k,1+titlelen+23).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95185"])==""?"0":"1"); //Ⅲ期
					objSheet.Cells(3+len+k,1+titlelen+24).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95186"])==""?"0":"1"); //Ⅳ期
					objSheet.Cells(3+len+k,1+titlelen+25).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95187"])==""?"0":"1"); //可疑深度组织损伤
					objSheet.Cells(3+len+k,1+titlelen+26).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95188"])==""?"0":"1"); //难以分期
					objSheet.Cells(3+len+k,1+titlelen+27).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"]);  //压疮面积长 
					objSheet.Cells(3+len+k,1+titlelen+28).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"]);  //压疮面积宽
					objSheet.Cells(3+len+k,1+titlelen+29).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94251"]);  //压疮面积深
				}
			}
			if(Ulcerlen!=0){
				len=len+Ulcerlen;
			}
	  	}
	}
	
	RepType=RepType.replace("/","或");
	StDate=StDate.replace(/(\/)/g,"-");
	EndDate=EndDate.replace(/(\/)/g,"-");

	succflag=xlBook.SaveAs(filePath+RepType+StDate+"至"+EndDate+".xls");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}
///不良事件按类型全部导出
function ExportAllData(StDate,EndDate,typeevent,filePath)
{ 
	var  strjData="",succflag="false"

	runClassMethod("web.DHCADVCOMMONPRINT","GetExportAllData",
	{StDate:StDate,EndDate:EndDate,reporttype:typeevent},function(ret){				
		strjData=ret;
	},"json",false);
	//var data=DataList.split("$$")
	var strjLen=strjData.length;
	//1、获取XLS导出路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_ExportAll.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(strjLen+2,18)).Borders.LineStyle=1;  //设置边框
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(strjLen+2,18)).WrapText=true; //自动换行
	for (i=1;i<=strjLen;i++)
	{
	//S DataList=RepDate_"^"_RepLoc_"^"_RepType_"^"_AdmNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatDiag_"^"_OccurDate_"^"_OccurLoc_"^"_status
		   
	    objSheet.cells(i+2,1)="'"+strjData[i-1].PatName;
	    objSheet.cells(i+2,2)="'"+strjData[i-1].PatSex;
	    objSheet.cells(i+2,3)="'"+strjData[i-1].PatAge;
	    objSheet.cells(i+2,4)="'"+strjData[i-1].AdmNo;
	    objSheet.cells(i+2,5)="'"+strjData[i-1].PatID;
	    objSheet.cells(i+2,6)="'"+strjData[i-1].PatDiag; 
	    objSheet.cells(i+2,7)="'"+strjData[i-1].PatAdmDate; //入院日期
	    objSheet.cells(i+2,8)="'"+strjData[i-1].DischgDate;  //出院日期
	    objSheet.cells(i+2,9)="'"+strjData[i-1].NurLev;  //护理级别
	    objSheet.cells(i+2,10)="'"+strjData[i-1].DegreeEducate;  //文化程度
	    objSheet.cells(i+2,11)="'"+strjData[i-1].RepLoc;  //报告科室
	    objSheet.cells(i+2,12)="'"+strjData[i-1].LocDep;  //报告大科室
	    objSheet.cells(i+2,13)="'"+strjData[i-1].RepDate;  //报告日期
	    objSheet.cells(i+2,14)="'"+strjData[i-1].OccurDate; //发生日期
	    objSheet.cells(i+2,15)="'"+strjData[i-1].RepStaus; //报告状态
	    objSheet.cells(i+2,16)="'"+strjData[i-1].OccurLoc; //发生科室
	    objSheet.cells(i+2,17)="'"; //发布共享
	    objSheet.cells(i+2,18)="'"+strjData[i-1].RepType;
	    

	}
	StDate=StDate.replace(/(\/)/g,"-");
	EndDate=EndDate.replace(/(\/)/g,"-");
	succflag=xlBook.SaveAs(filePath+"不良事件导出统计"+StDate+"至"+EndDate+".xls");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}
///不良事件按类型全部导出
function ExportGatherData(StDate,EndDate,typeevent,filePath)
{ 
	var  strjData="",succflag="false"

	runClassMethod("web.DHCADVCOMMONPRINT","GetExportAllData",
	{StDate:StDate,EndDate:EndDate,reporttype:typeevent},function(ret){				
		strjData=ret;
	},"json",false);
	//var data=DataList.split("$$")
	var strjLen=strjData.length;
	//1、获取XLS导出路径
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_ExportGather.xlsx";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	
	objSheet.cells(1,1)="'"+StDate.split("-")[0]+"年护理不良事件（"+StDate+"至"+EndDate+")"; //标题
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(1+strjLen+2,9)).Borders.LineStyle=1;  //设置边框
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(1+strjLen+2,9)).WrapText=true; //自动换行
	for (i=1;i<=strjLen;i++)
	{
	    objSheet.cells(i+2,1)="'"+i; //序号
	    objSheet.cells(i+2,2)="'"+strjData[i-1].RepLoc; //报告日期
	    objSheet.cells(i+2,3)="'"+strjData[i-1].PatName;
	    objSheet.cells(i+2,4)="'"+strjData[i-1].PatSex;
	    objSheet.cells(i+2,5)="'"+strjData[i-1].PatAge;
	    objSheet.cells(i+2,6)="'"+strjData[i-1].AdmNo;
	    objSheet.cells(i+2,7)="'"+strjData[i-1].PatDiag; 
	    objSheet.cells(i+2,8)="'"+strjData[i-1].RepDate;  //报告日期
	    objSheet.cells(i+2,9)="'"+strjData[i-1].RepTypeExp;
	}

	xlApp.Range(xlApp.Cells(3+strjLen,1),xlApp.Cells(3+strjLen,9)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(3+strjLen,1),xlApp.Cells(3+strjLen,9)).WrapText=true; //自动换行
	objSheet.cells(3+strjLen,1)="'"+"合计（例）："+"院外压疮："+strjData[strjLen-1].ulcerout+"；院内压疮："+strjData[strjLen-1].ulcernumall+"；管路滑脱："+strjData[strjLen-1].Pipenum+"；跌倒坠床："+strjData[strjLen-1].Fallnum+"；一次性医疗用品："+strjData[strjLen-1].Mednum+"；用药错误："+strjData[strjLen-1].Drugerrnum+"；意外伤害："+strjData[strjLen-1].Accidentnum+"；医疗护理风险防范："+strjData[strjLen-1].Wallnum+"。";	
	//objSheet.cells(2+strjLen,1)="'"+"合计（例）："+"压疮："+strjData[strjLen-1].Ulcernum+"；管路滑脱："+strjData[strjLen-1].Pipenum+"；跌倒坠床："+strjData[strjLen-1].Fallnum+"；一次性医疗用品："+strjData[strjLen-1].Mednum+"；用药错误："+strjData[strjLen-1].Drugerrnum+"；意外伤害："+strjData[strjLen-1].Accidentnum+"；医疗护理风险防范："+strjData[strjLen-1].Wallnum+"。";	
	
	StDate=StDate.replace(/(\/)/g,"-");
	EndDate=EndDate.replace(/(\/)/g,"-");

	succflag=xlBook.SaveAs(filePath+"护理不良事件"+StDate+"至"+EndDate+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}


//处理未定义的变量
function $g(param){
	return param==undefined?"":	param;
}
//radio和checkbox数据获取
function radioValue(param,data){
	var ret=[]
	
	if(param==="") return "";
	paramArray = param.split(",");
	
	for(var i =0;i<paramArray.length;i++){
		if($g(data[paramArray[i]])!=""){
			ret.push($g(data[paramArray[i]]));
		}
	}
	
	return ret.join("； ");
}

//radio和checkbox数据获取  带有子元素拼串
function checksubValue(data,param,subdata){
	//alert(param);
	var ret=[]
	if(param==="") return "";
	paramArray = param.split(",");
	for(var i =0;i<paramArray.length;i++){
		if($g(subdata[paramArray[i]])!=""){
			ret.push($g(subdata[paramArray[i]]));
		}
	}
	if (ret.join("； ")!=""){
		data=data+"（"+ret.join("； ")+"）";
	}
	return data;
}
function myRadioValue(param,data){
	var ret = radioValue(param,data);
	if(ret===""){
		ret="无";
	}
	return ret;
}
