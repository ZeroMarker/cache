//全局变量用作垃圾回收用
var idTmr=""
var valRegNo=""
function outPutInfo(infoStr,stationName,gName){
	//创建一个excel工作薄
	var xls=createExcle();
	var xlBook = xls.Workbooks.Add;
	//xlBook=xls.Workbooks.Open(""d:\\dhcpeTemp\\test.xls");
	var fdir="d:\\dhcpeTemp";
	//创建目录
	createFolder(fdir);

	//保存数据
	//alert(infoStr)
	valRegNo="";
	xlBood=writer(xls,xlBook,infoStr);

	//保存excel文件
	var xlsName=gName+"_"+stationName
	xlBood=saveXls(xlBood,fdir,xlsName);
	
	//清空excel的进程
	cleanXlsObj(xls,xlBook);

}
///cteator:wangfujian
//cteateDate:2009-03-16
///description:创建一个excel表格
///return:excel表格对象
function createExcle(){
	 try {
      var xls    = new ActiveXObject ( "Excel.Application" );
     }
    catch(e) {
         alert( "要打印该表?您必须安装Excel电子表格软件?同时浏览器须使用?ActiveX 控件??您的浏览器须允许执行控件? 请点击?帮助?了解浏览器设置方法?");
              return "";
     }
	  xls.visible =false;  //设置excel为不可见
	 xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制
	return xls;
}
///cteator:wangfujian
//cteateDate:2009-03-16
///description:打开一个excel的报表
///input:excel表格xlBook?报名的名词?位置
///return:Sheet报表
function openSheet(xlBook,sheetName,sheetNum){

    var xlsheet = xlBook.Worksheets(sheetNum);
    xlsheet.Name=sheetName;
	return xlsheet;
}
//cteateDate:2009-03-16
///description:像excel中的工作薄写入内容
///return:excel的工作薄对象,写入内容的字符串?
//"东华合创_体检,汪福建^00111^24^男^科室%体检大项$心电@心率&内科%内科专业检查$心电@心率##"
function writer(xls,xlBook,inStr){
	
	//var inStr="内科,东华合创_体检||汪福建^00111^24^男^科室%体检大项$心电@心率&内科%内科专业检查$心电@心率##汪福建^00111^24^男^科室%体检大项$心电@心率&内科%内科专业检查$心电@心率#汪福建^00111^24^男^科室%体检大项$心电@心率&内科%内科专业检查$心电@心率#汪福建^00111^24^男^科室%体检大项$心电@心率&内科%内科专业检查$心电@心率#汪福建^00111^24^男^科室%体检大项$心电@心率&内科%内科专业检查$心电@心率#汪福建^00111^24^男^科室%体检大项$心电@心率&内科%内科专业检查$心电@心率#汪福建^00111^24^男^科室%体检大项$心电@心率&内科%内科专业检查$心电@心率#汪福建^00111^24^男^科室%体检大项$心电@心率&内科%内科专业检查$心电@心率#汪福建^00111^24^男^科室%体检大项$心电@心率&内科%内科专业检查$心电@心率#;东华合创_收费,汪会才^00111^24^男^;"
    var ExcelSheet = "";
    var station=inStr.split(",")[0];
    var groups=inStr.split(",")[1];

	var groupsStr=groups.split(";");
	var teamNum=0;
	//输出一个组的信息
	for (var i=0;i<groupsStr.length ;i++ ){
		if(groupsStr[i]==""){
			continue;
		}
		
		var groupInfo=groupsStr[i];
		var groupName=groupInfo.split("||")[0];
		var title=groupName;
		var persons=groupInfo.split("||")[1];
		teamNum=teamNum+1;
		var currRow=1;
		//为一个组新建一个报表
		ExcelSheet=openSheet(xlBook,groupName,teamNum);
		//设置标题,行高
		ExcelSheet.Rows(currRow).RowHeight = 25;
		ExcelSheet.Range(ExcelSheet.Cells(currRow,1),ExcelSheet.Cells(currRow,4)).Interior.ColorIndex=34;
		ExcelSheet.Range(ExcelSheet.Cells(currRow,1),ExcelSheet.Cells(currRow,4)).mergecells=true;
		ExcelSheet.Range(ExcelSheet.Cells(currRow,1),ExcelSheet.Cells(currRow,4)).value=title;
		currRow=currRow+1
		var personsInfo=persons.split("#");
		//alert(personsInfo)
		//输出一个人员信息
		for (var j=0;j<personsInfo.length ;j++ )
		{
			if (personsInfo[j]=="")
			{
				continue;
			}
			//alert(personsInfo[j])
			currRow=putPersonInfo(ExcelSheet,personsInfo[j],currRow);
		
			
		
		}
	//设置列自动适应内容?把全部内容都显示出来
	ExcelSheet.Columns("A:D").ColumnWidth =25;
	ExcelSheet.Range( ExcelSheet.Cells(1,1),ExcelSheet.Cells(1,4)).HorizontalAlignment =3;//居中
	
		
	}
	return xlBook;
	
}

//cteateDate:2009-03-16
///description:向工作薄中写入一个人的信息
///input:excel的工作薄对象?个人信息?当前的开始行数
///return:当前结束行数:"rurrRow#ExcelSheet"
function putPersonInfo(ExcelSheet,personInfo,currRow){
	
	var colorRow=currRow;
	//设置个人的基本信息
	var iAdm=personInfo;
	var name=iAdm.split("^")[0];
	var regNo=iAdm.split("^")[1];
	var sex=iAdm.split("^")[3];
	var age=iAdm.split("^")[2];
	var orders=iAdm.split("^")[4];
	if (regNo!=valRegNo)
	{
		ExcelSheet.Cells(currRow,1).Value="姓名";
		ExcelSheet.Cells(currRow,2).Value="登记号";
		ExcelSheet.Cells(currRow,3).Value="性别";
		ExcelSheet.Cells(currRow,4).Value="年龄";
		
		currRow=currRow+1;
		//人的基本信息
		ExcelSheet.Cells(currRow,1).Value=name;
		ExcelSheet.Cells(currRow,2).Value=regNo;	
		ExcelSheet.Cells(currRow,3).Value=sex;
		ExcelSheet.Cells(currRow,4).Value=age;
		//将每个人都基本信息加上背景色
		ExcelSheet.Range(ExcelSheet.Cells(colorRow,1),ExcelSheet.Cells(currRow,4)).Interior.ColorIndex=15;
		ExcelSheet.Range( ExcelSheet.Cells(currRow-1,1),ExcelSheet.Cells(currRow,4)).HorizontalAlignment =3;//居中
		currRow=currRow+1;
		valRegNo=regNo;
	}
			
	var orderArray=orders.split("&");
	for (var m=1;m<=orderArray.length ;m++ )
	{
		if (orderArray[m-1]=="")
		{
			continue;
		}
		var orderTitle=orderArray[m-1].split("$")[0];
		var orderDetails=orderArray[m-1].split("$")[1]
		//设置大项的标题
		var station=orderTitle.split("%")[0];
		var orderName=orderTitle.split("%")[1];
		/* 把下面两行注释掉就去掉了科室这一行*/
		//ExcelSheet.Cells(currRow,1).Value=station;
		//currRow=currRow+1;
		ExcelSheet.Cells(currRow,1).Value=orderName;
		var detailArray=orderDetails.split("@");
		if (detailArray.length>1){
			if 	(!(detailArray[1].split("-检查结果").length>1)) ExcelSheet.Cells(currRow,2).Value="结果";
		}
		ExcelSheet.Range(ExcelSheet.Cells(currRow,2),ExcelSheet.Cells(currRow,4)).mergecells=true;
		currRow=currRow+1;
		
		for (var n=0;n<detailArray.length ;n++ )
		{
			if 	(detailArray[n].split("-检查结果").length>1) continue;
			ExcelSheet.Cells(currRow,1).Value=detailArray[n];
			ExcelSheet.Range(ExcelSheet.Cells(currRow,2),ExcelSheet.Cells(currRow,4)).mergecells=true;
						
			currRow=currRow+1;
		}
		

	}
	return currRow;
			
}
//cteateDate:2009-03-16
///description:保存一个工作薄
///input:excel的工作薄对象
function saveXls(xlBook,fdir,fName){
	var flag=2
	//打开一个文件对象
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	for(var i=1;i<flag;i++){
		if(!fso.FileExists(fdir+"\\"+fName+i+".XLS")){
			xlBook.SaveAs(fdir+"\\"+fName+i+".XLS");  // 保存表格
		}else{
			flag=flag+1;
		}
	}
	
}

//cteateDate:2009-03-16
///description:清空所有工作薄的对象
///input:
function cleanXlsObj(xls,xlBook){
	xlBook.Close(savechanges=true) ;
	xls.Quit();
	xls=null;
	xlBook=null;
	//将此进程垃圾回收
	 idTmr = window.setInterval("Cleanup();",1);

}

//cteateDate:2009-03-16
///description:js的垃圾回收
///input:
  function Cleanup() {
    window.clearInterval(idTmr);
    CollectGarbage();
  }

//cteateDate:2009-03-16
///description:创建文件夹,如果文件夹存在?不创建?不存在则创建
///input:文件夹的路径?如?"d:\\dhcpeTemp"
function createFolder(fdir){
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(!fso.FolderExists(fdir)){
		fso.CreateFolder(fdir);
	}
}
///author:wangfujian
///createDate:2009-03-26
///description:按站点导出一个团体所有人员信息及医嘱信息到excel表中
function outputInfo_click(){
 
	var obj=window.event.srcElement;
	if(obj.disabled){
		return;
	}
	//先初始化需要到处都站点名
	var stationsObj=document.getElementById("getStationBox");
	var encahe=stationsObj.value;
	//var stations="一般检查,^内科,^外科,^妇科,^眼科,^耳鼻喉科,"
	var stations=cspRunServerMethod(encahe);
	var outputInfo=stations.split("^");
   
	//取得团体的PreGADMRowid和团体名词
	var preGADMRowid=""
	obj=document.getElementById("RowId");
	if (obj){ 
		preGADMRowid=obj.value; 
	}
	obj=document.getElementById('RowId_Name');
	if (obj){ 
		GName=obj.value; 
	}
 
	//通过preGADMRowid获得该团体的所有成员的PAADM
	obj=document.getElementById("getPAADMsByPreGADMBox");
	var encahe=obj.value;
	var PAADMs=cspRunServerMethod(encahe,preGADMRowid);
	//PAADMs="10988^39394"
	if(PAADMs==""){
		alert("没有需要导出的信息!");
		return;
	}
	 
	//取出病人数量
	var patientNum="";
	var PAADMArray=PAADMs.split("^");
	patientNum=PAADMArray.length;
	for(var i=0;i<patientNum;i++){
		var currPAADMInfo=PAADMArray[i];
		var currPAADMRowid=currPAADMInfo.split("#")[0]
		var currPatientTeamName=currPAADMInfo.split("#")[1]
		//同过PAADM得到个人需要导出的信息
		var encache="";
		var obj=document.getElementById("outputInfoBox");
		if(obj){
			var encache=obj.value;
		}
		//得到一个人的信息
		
		var admInfo=cspRunServerMethod(encache,currPAADMRowid);

		//科室排序?一般检查?内科?外科?妇科?眼科?耳鼻喉科?这个一定要跟站点联系上
		var iadmBaseInfo= admInfo.split("#")[0];
		var stationInfo=admInfo.split("#")[1];
		
		var iadmStationInfo=stationInfo.split("&");
      
		for(var m=0;m<iadmStationInfo.length;m++){
			
			if(iadmStationInfo[m]==""){
				continue;
			}
			for(var j=0;j<outputInfo.length;j++){
				
				var sation=outputInfo[j].split(",")[0];
				
				var teamInfo=outputInfo[j].split(",")[1];
				if(iadmStationInfo[m].split("%")[0]==sation){
					//把个人信息加入到相应的站点和分组
				
					if(teamInfo==""){
						outputInfo[j]=sation+","+currPatientTeamName+"||"+iadmBaseInfo+"^"+iadmStationInfo[m]+"#;";
					}else{
						//outputInfo[j]="内科,cache||wangfujian#wanghuicai;java||wangfujian#wanghuicai"
						var allTeams=teamInfo.split(";")
						var isNewTeamFlag=0
						for(var k=0;k<allTeams.length;k++){
							if(allTeams[k]==""){
								continue;
							}
			
							if(allTeams[k].split("||")[0]==currPatientTeamName){
								//allTeams[k]=allTeams[k]+iadmBaseInfo+"^"+iadmStationInfo[m]
								if(k==0){
									outputInfo[j]=sation+","+allTeams[k]+iadmBaseInfo+"^"+iadmStationInfo[m]+"#;";
								}else{
									outputInfo[j]=outputInfo[j]+allTeams[k]+iadmBaseInfo+"^"+iadmStationInfo[m]+"#;";
								}
								isNewTeamFlag=1
							}else{
								if(k==0){
									outputInfo[j]=sation+","+allTeams[k]+";";
								}else{
									outputInfo[j]=outputInfo[j]+allTeams[k]+";"
								}
							}
						}
						if(isNewTeamFlag==0){
							outputInfo[j]=outputInfo[j]+currPatientTeamName+"||"+iadmBaseInfo+"^"+iadmStationInfo[m]+"#;";
						}
					}
	
				}
			}
			
		}
	}
	
	//将所有的信息都导出了
	var outFlag=0
	for(var j=0;j<outputInfo.length;j++){

		if(outputInfo[j].split(",")[1]!=""){
			
			//导出信息
			//dhcpeOutputAdmInfo.JS中
			//站点名词
			var stationName=outputInfo[j].split(",")[0]

			outPutInfo(outputInfo[j],stationName,GName);
			outFlag=1
			
		}
	}
	if(outFlag==1){
		alert("成功导出到D:\dhcpeTemp目录下!")
	}else{
		alert("没有需要导出的信息!")
	}
	
}