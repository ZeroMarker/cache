/// 组件	DHCPEIAdmItemStatusAdms.PatItemPrint
///	前台工作站 打印导检单
///	2007/06/28  斑马888-TT
///	-----------------------
///	Create by xuwm
///	Description: 执行打印导检单的功能
var   idTmr   =   "";
var xlApp="",xlBook="",xlsheet=""
function Print(value,PrintFlag,viewmark)
{
	if (value=="") return false;
	var OEItemPrint="";
	var obj=document.getElementById("OEItemPrint");
	if (obj) OEItemPrint=obj.value;
	if (OEItemPrint!="") DHCP_GetXMLConfig("InvPrintEncrypt",OEItemPrint);
	var Page="A4"
	var obj=document.getElementById("PageModel");
	if (obj) Page=obj.value;
  
	if (Page=="A4")
	{
		PrintA4(value,PrintFlag,viewmark);
	}
	else if (Page=="A5")
	{
		PrintA5(value);
	}
	return false;
}
function PrintA5(value)  //友谊
{
	
	var TxtInfo="",ListInfo="";
	var Char_2=String.fromCharCode(2);
	var vals=value.split("#");
	
	// 患者信息
	PatInfos=vals[0].split(";");
	
	var PatTag=PatInfos[0].split("^"); // 标签
	var PatInf=PatInfos[1].split("^"); // 值

	for (var iLLoop=0;iLLoop<PatTag.length;iLLoop++){
		TxtInfo=TxtInfo+PatTag[iLLoop]+Char_2+PatInf[iLLoop]+"^";
	}	
	// 检验项目
	ListInfo="";
	var OEItems=vals[1].split(";");

	var ShortLine="____________";
	var NullLine="            ";
	var Line1="__________________________________"
	var Line2="________________";
	var Line3="___________";
	var Line4="___________________";
	var LineStr="";
	for (var iLLoop=0;iLLoop<OEItems.length-1;iLLoop++){
		OEItem=OEItems[iLLoop].split("^");
	
		if (""!=OEItem[0]) var ItemName=OEItem[0]
		
		if (OEItem[0]==""){LineStr=NullLine+"^"+Line1+"^"+Line4+"^"+Line3;}
		if (OEItem[0]!=""){LineStr=ShortLine+"^"+Line1+"^"+Line4+"^"+Line3;}
		if (iLLoop!=OEItems.length-1)
		{
			var NextItem=OEItems[iLLoop+1].split("^")[0];
			if (NextItem!=""){LineStr=ShortLine+"^"+Line1+"^"+Line4+"^"+Line3;}
			if (NextItem==""){LineStr=NullLine+"^"+Line1+"^"+Line4+"^"+Line3;}
			if (OEItem[4]==OEItems[iLLoop+1].split("^")[4]){LineStr="^^^";}
		}
		if (0==(iLLoop+1) % 31) {LineStr="^^^";}   //如果是本页最后以行去掉横线
		if (1==(iLLoop+1) % 31) {OEItem[0]=ItemName;} //如果是后续页打印出来类别与流程
		 				 // 横线	      类别流程 1	项目 2		注意事项 3
		ListInfo=ListInfo+LineStr+"^"+OEItem[0]+"^"+OEItem[1]+"^"+OEItem[2]+"^"+OEItem[7]+Char_2;  //
		//分页 每页24行
		if ((0==(iLLoop+1) % 31)) {
			var myobj=document.getElementById("ClsBillPrint");
			DHCP_PrintFun(myobj,TxtInfo,ListInfo);
			//if (!DHCP_PrintFun(myobj,TxtInfo,ListInfo)) return false;
			//alert(ListInfo);
			ListInfo="";
		}
	}
	if (ListInfo!=""){	var myobj=document.getElementById("ClsBillPrint");
	
	if (!DHCP_PrintFun(myobj,TxtInfo,ListInfo)) return false;}

}
function PrintExcel(value,PrintFlag,viewmark)
{
	var WestFlag=0;
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
	}else{
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	}
	var Templatefilepath=prnpath+'DHCPENewDirect.xls';
	var Char_1=String.fromCharCode(1);
	var Char_2=String.fromCharCode(2);
	var Char_3=String.fromCharCode(3);
	var Char_0=String.fromCharCode(4);
	
	var Arr=value.split(Char_0);
	var BaseInfo=Arr[0];
	var BaseArr=BaseInfo.split("^");
	var VIPTemplateFile=tkMakeServerCall("web.DHCPE.PrintNewDirect","GetTemplateName",BaseArr[9]);
	if (VIPTemplateFile!=""){
	var Templatefile=VIPTemplateFile;
	if (PicFileIsExist("D:\\DHCPE\\"+Templatefile)){
		var Templatefilepath="D:\\DHCPE\\"+Templatefile;
	}
	else{
		var Templatefilepath=prnpath+Templatefile;
	}
	
	}

	

	if ((PrintFlag=="0")||(PrintFlag=="1")){
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Templatefilepath);
		xlsheet = xlBook.WorkSheets("Sheet1");
	}

	var CTNum=BaseArr[16];
	var RaxNum=BaseArr[17];
	var NJNum=BaseArr[18];
	var Remark=BaseArr[19];
	var DocName=BaseArr[20];
	var PInfo=BaseArr[8];

	if (((CTNum!=0)||(RaxNum!=0)||(NJNum!=0))&&(viewmark!=2))
	{
		//alert("CT项目有:"+CTNum+"个\n核磁项目有:"+RaxNum+"个"+"\n内镜项目有:"+NJNum+"个");
	}
	/*
	if(PInfo!="个人")
    {
	    xlsheet.cells(34,8).Value="集体体检";
    }
	*/

    var PrintItem=xlsheet.cells(1,1).Value;
    xlsheet.cells(1,1).Value="";
    var PrintDocName=DocName;
    xlsheet.cells(1,2).Value="";

	xlsheet.cells(1,8).Value=BaseArr[5];
	xlsheet.cells(2,1).Value=xlsheet.cells(2,1).Value+BaseArr[0];
	xlsheet.cells(2,4).Value=xlsheet.cells(2,4).Value+BaseArr[1];
	xlsheet.cells(2,5).Value=xlsheet.cells(2,5).Value+BaseArr[2];
	xlsheet.cells(2,7).Value=xlsheet.cells(2,7).Value+BaseArr[9];
	xlsheet.cells(2,10).Value=xlsheet.cells(2,10).Value+BaseArr[3];
	if (WestFlag==1) xlsheet.cells(9,9).Value="*"+BaseArr[4]+"*";
	xlsheet.cells(3,1).Value=xlsheet.cells(3,1).Value+BaseArr[4];
	xlsheet.cells(3,5).Value=xlsheet.cells(3,5).Value+BaseArr[6];
	xlsheet.cells(3,8).Value=xlsheet.cells(3,8).Value+BaseArr[7];
	xlsheet.cells(4,1).Value=xlsheet.cells(4,1).Value+BaseArr[8];
	xlsheet.cells(4,6).Value=xlsheet.cells(4,6).Value+BaseArr[10];
	xlsheet.cells(4,9).Value=xlsheet.cells(4,9).Value+Remark;
	xlsheet.cells(5,1).Value=xlsheet.cells(5,1).Value+BaseArr[15];
	xlsheet.cells(7,9).Value=BaseArr[11];
	var obj=document.getElementById("NoPrintAmount");
	if (obj&&obj.checked) { xlsheet.cells(7,9).Value="" }
	else{
		xlsheet.cells(7,9).Value=BaseArr[11];
	}

	xlsheet.cells(9,11).Value=BaseArr[14];
	if(BaseArr[14]==""){xlsheet.cells(8,11).Value="";}
	xlsheet.Range(xlsheet.cells(7,1),xlsheet.cells(7,11)).BorderS(4).LineStyle=7;
	xlsheet.Range(xlsheet.cells(10,1),xlsheet.cells(10,11)).BorderS(4).LineStyle=7;
	xlsheet.Range(xlsheet.cells(11,1),xlsheet.cells(11,11)).BorderS(4).LineStyle=7;
	
	var DietDesc=BaseArr[12];
	var PhotoDesc=BaseArr[13];
	if (DietDesc!=""){
		DietDesc=DietDesc+"  "+PhotoDesc;
	}else{
		DietDesc=PhotoDesc;
	}
	xlsheet.cells(1,1).Value=DietDesc;
		
		
	if ((VIPTemplateFile!="DHCPENewDirectGR.xls")){
	try{
		var msoShaoeRectangle=1;
		var ShapeRange=xlsheet.Shapes.AddShape(msoShaoeRectangle, 10, 10, 60, 75);
		ShapeRange.Line.Visible = false;
		//alert(BaseArr[5].split("*")[1])
		//var imgStr=tkMakeServerCall("web.DHCPE.PrintNewDirect","GetPhotoPath",BaseArr[5].split("*")[1]);
		//alert(imgStr)
		ShapeRange.Fill.UserPicture(imgStr); 
	}catch(e){
		ShapeRange.Visible=false;
	}
	}

	/*
	指引单类别^注意事项$C(2)ItemDesc^AddFlag$C(3)ItemDesc^AddFlag$C(1)指引单类别^注意事项$C(2)ItemDesc^AddFlag$C(3)ItemDesc^AddFlag
	*/
	var ItemInfo=Arr[1];
	var PatArr=ItemInfo.split(Char_1);
	var PatLength=PatArr.length;
	var StartRow=12;
	var AddRow=0;
	var RowNum=5;
	var m=0;
	for (var i=0;i<PatLength;i++)
	{
		var OnePatInfo=PatArr[i];
		var OneArr=OnePatInfo.split(Char_2);
		var PatInfo=OneArr[0];
		var CurPatArr=PatInfo.split("^");
		var PatItemInfo=OneArr[1];
		//设置导检单类别
		xlsheet.cells(StartRow+AddRow,1).Value=CurPatArr[0];
		//第一个的加粗16号字
		xlsheet.Cells(StartRow+AddRow,1).Font.Bold = true;
		xlsheet.Cells(StartRow+AddRow,1).Font.Size = 14;
		//xlsheet.Range(xlsheet.Cells(StartRow+AddRow,4),xlsheet.Cells(StartRow+AddRow,9)).mergecells=true;  //合并
		//xlsheet.Cells(StartRow+AddRow,4).WrapText=true; //自动换行
		if (CurPatArr[2]=="Y") {xlsheet.cells(StartRow+AddRow,10).Value="医生签名:";}
		
		var NoticeArr=CurPatArr[1].split("&");
		var NoticeArrLength=NoticeArr.length;
		var m=m+NoticeArrLength;
		for (var Arrj=0;Arrj<NoticeArrLength;Arrj++)
		{
			AddRow=AddRow+Arrj;
			//AddRow=m-NoticeArrLength+Arrj;
			xlsheet.cells(StartRow+AddRow,4).Value=NoticeArr[Arrj];
		}
		//xlsheet.cells(StartRow+AddRow,4).Value=CurPatArr[1];
		
		var SignNameFlag=CurPatArr[3];
		
		if(CurPatArr[0].indexOf("超声检查") > 0 )
		{
    		RowNum=1;
		}
		else
		{
			RowNum=5;
			
		}
		if (PatItemInfo!="")
		{   
		
		   
			var ItemArr=PatItemInfo.split(Char_3);
			var ItemLength=ItemArr.length;
			var TotalRow=Math.ceil(ItemLength/RowNum) 
			for (var j=0;j<TotalRow;j++)
			{
				AddRow=AddRow+1;
				for (var k=0;k<RowNum;k++)
				{
					var Num=j*RowNum+k
					if (Num==ItemLength) break;
					var OneItem=ItemArr[Num];
					var OneItemArr=OneItem.split("^");
					xlsheet.cells(StartRow+AddRow,(k+1)*2).Value=OneItemArr[0];
					//如果是加项，字体加下划线
					if (OneItemArr[1]=="1")
					{
						xlsheet.cells(StartRow+AddRow,(k+1)*2).Font.Underline = true;
					}
				}
			}
			//AddRow=AddRow+1;
		}
	
		if (SignNameFlag=="Y") AddRow=AddRow+1;
		//xlsheet.Cells(AddRow,1).Borders.Weight = 1;
		//画下面边框粗线
		xlsheet.Range(xlsheet.cells(StartRow+AddRow,1),xlsheet.cells(StartRow+AddRow,11)).BorderS(4).LineStyle=7
		AddRow=AddRow+1
	}
	//alert(PrintFlag)
	//alert("AddRow"+AddRow)
	//alert(viewmark)
    if(viewmark==2){
		xlApp.Visible = true;
		xlsheet.PrintPreview; // 打印预览   
		xlBook.Close(false); //
		xlApp=null;
		xlsheet=null;
	//xlsheet.PrintPreview
	//xlApp.Visible = true;
		return false;	
    }else{
		xlsheet.printout
		xlBook.Close (savechanges=false);
        xlApp=null;
        xlsheet=null;
        CollectGarbage();

    }
    
    return false;
	///至此赋值打印完成，下面是清除本次打印的数据。。。
	
	
	xlsheet.cells(2,1).Value=xlsheet.cells(2,1).Value.split("：")[0]+"：";
	xlsheet.cells(2,4).Value=xlsheet.cells(2,4).Value.split("：")[0]+"：";
	xlsheet.cells(2,5).Value=xlsheet.cells(2,5).Value.split("：")[0]+"：";
	xlsheet.cells(2,7).Value=xlsheet.cells(2,7).Value.split("：")[0]+"：";
	xlsheet.cells(2,10).Value=xlsheet.cells(2,10).Value.split("：")[0]+"：";
	xlsheet.cells(3,1).Value=xlsheet.cells(3,1).Value.split("：")[0]+"：";
	xlsheet.cells(3,5).Value=xlsheet.cells(3,5).Value.split("：")[0]+"：";
	xlsheet.cells(3,8).Value=xlsheet.cells(3,8).Value.split("：")[0]+"：";
	xlsheet.cells(4,1).Value=xlsheet.cells(4,1).Value.split("：")[0]+"：";
	xlsheet.cells(4,6).Value=xlsheet.cells(4,6).Value.split("：")[0]+"：";
	xlsheet.cells(4,9).Value=xlsheet.cells(4,9).Value.split("：")[0]+"：";
	xlsheet.cells(5,1).Value=xlsheet.cells(5,1).Value.split("：")[0]+"：";
	
	var StartRow=12;
	var AddRow=0;
	var RowNum=5;
	
	for (var i=0;i<PatLength;i++)
	{
		var OnePatInfo=PatArr[i];
		var OneArr=OnePatInfo.split(Char_2);
		var PatInfo=OneArr[0];
		var CurPatArr=PatInfo.split("^");
		var PatItemInfo=OneArr[1];
		//设置导检单类别
		xlsheet.cells(StartRow+AddRow,1).Value="";
		//第一个的加粗16号字
		xlsheet.Cells(StartRow+AddRow,1).Font.Bold = false;
		xlsheet.Cells(StartRow+AddRow,1).Font.Size = 11;
		xlsheet.cells(StartRow+AddRow,4).Value="";
		if (CurPatArr[2]=="Y") {xlsheet.cells(StartRow+AddRow,10).Value="";}
		var SignNameFlag=CurPatArr[3];
		if(CurPatArr[0].indexOf("超声检查") > 0 )
		{
    		RowNum=1;
		}
		else
		{
			RowNum=5;
			
		}
		if (PatItemInfo!="")
		{
			var ItemArr=PatItemInfo.split(Char_3);
			var ItemLength=ItemArr.length;
			var TotalRow=Math.ceil(ItemLength/RowNum) 
			for (var j=0;j<TotalRow;j++)
			{
				AddRow=AddRow+1;
				for (var k=0;k<RowNum;k++)
				{
					var Num=j*RowNum+k
					if (Num==ItemLength) break;
					var OneItem=ItemArr[Num];
					var OneItemArr=OneItem.split("^");
					xlsheet.cells(StartRow+AddRow,(k+1)*2).Value="";
					//如果是加项，字体加下划线
					if (OneItemArr[1]=="1")
					{
						xlsheet.cells(StartRow+AddRow,(k+1)*2).Font.Underline = false;
					}
				}
			}
			//AddRow=AddRow+1;
		}
		if (SignNameFlag=="Y") AddRow=AddRow+1;
		//xlsheet.Cells(AddRow,1).Borders.Weight = 1;
		//画下面边框粗线
		xlsheet.Range(xlsheet.cells(StartRow+AddRow,1),xlsheet.cells(StartRow+AddRow,11)).BorderS(4).LineStyle=0
		AddRow=AddRow+1
		
	}
		
	
	if ((PrintFlag=="2")||(PrintFlag=="1")){
		//alert("cx")
		//xlsheet.printout
		//xlsheet.saveas("d:\\aa.xls")
		xlBook.Close (savechanges=false);
		xlApp=null;
		xlsheet=null;
		idTmr = window.setInterval("Cleanup();",1);
	}
	return false;

}
/// 导引单备份
function Printbenfen(value)
{
	//DHCPENewDirect.xls
	/*
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPENewDirect.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	*/
	//alert(value)
	var Templatefilepath="D:\\DHCPENewDirect.xls"
	var Char_1=String.fromCharCode(1);
	var Char_2=String.fromCharCode(2);
	var Char_3=String.fromCharCode(3);
	var Char_0=String.fromCharCode(4);
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	//xlsheet.cells(l+2,1).Value=BaseInfo[7]; 
	var Arr=value.split(Char_0);
	var BaseInfo=Arr[0];
	/*
	s BaseInfo=PatName_"^"_Sex_"^"_PatAge_"^"_MobilePhone_"^"_RegNo_"^"_BarRegNo
	s BaseInfo=BaseInfo_"^"_RegDate_"^"_OrderSetsDesc_"^"_Company_"^"_VIPType
	s BaseInfo=BaseInfo_"^"_Position_"^"_TotalFee_"^"_DietDesc_"^"_PhotoDesc_"^"_AddItem
	*/
	//alert('a')
	var BaseArr=BaseInfo.split("^");
	xlsheet.cells(1,8).Value=BaseArr[5];
	xlsheet.cells(2,1).Value=xlsheet.cells(2,1).Value+BaseArr[0];
	xlsheet.cells(2,4).Value=xlsheet.cells(2,4).Value+BaseArr[1];
	xlsheet.cells(2,5).Value=xlsheet.cells(2,5).Value+BaseArr[2];
	xlsheet.cells(2,7).Value=xlsheet.cells(2,7).Value+BaseArr[3];
	xlsheet.cells(2,10).Value=xlsheet.cells(2,10).Value+BaseArr[9];
	xlsheet.cells(3,1).Value=xlsheet.cells(3,1).Value+BaseArr[4];
	xlsheet.cells(3,5).Value=xlsheet.cells(3,5).Value+BaseArr[6];
	xlsheet.cells(3,8).Value=xlsheet.cells(3,8).Value+BaseArr[7];
	xlsheet.cells(4,1).Value=xlsheet.cells(4,1).Value+BaseArr[8];
	xlsheet.cells(4,7).Value=xlsheet.cells(4,7).Value+BaseArr[10];
	xlsheet.cells(5,1).Value=xlsheet.cells(5,1).Value+BaseArr[14];
	xlsheet.cells(7,9).Value=BaseArr[11];
	xlsheet.Range(xlsheet.cells(7,1),xlsheet.cells(7,11)).BorderS(4).LineStyle=7;
	xlsheet.Range(xlsheet.cells(10,1),xlsheet.cells(10,11)).BorderS(4).LineStyle=7;
	xlsheet.Range(xlsheet.cells(11,1),xlsheet.cells(11,11)).BorderS(4).LineStyle=7;
	
	var DietDesc=BaseArr[12];
	var PhotoDesc=BaseArr[13];
	if (DietDesc!=""){
		DietDesc=DietDesc+"  "+PhotoDesc;
	}else{
		DietDesc=PhotoDesc;
	}
	xlsheet.cells(1,1).Value=DietDesc;
	/*
	指引单类别^注意事项$C(2)ItemDesc^AddFlag$C(3)ItemDesc^AddFlag$C(1)指引单类别^注意事项$C(2)ItemDesc^AddFlag$C(3)ItemDesc^AddFlag
	*/
	var ItemInfo=Arr[1];
	var PatArr=ItemInfo.split(Char_1);
	var PatLength=PatArr.length;
	var StartRow=12;
	var AddRow=0;
	var RowNum=5;
	for (var i=0;i<PatLength;i++)
	{
		var OnePatInfo=PatArr[i];
		var OneArr=OnePatInfo.split(Char_2);
		var PatInfo=OneArr[0];
		var CurPatArr=PatInfo.split("^");
		var PatItemInfo=OneArr[1];
		//设置导检单类别
		xlsheet.cells(StartRow+AddRow,1).Value=CurPatArr[0];
		//第一个的加粗16号字
		xlsheet.Cells(StartRow+AddRow,1).Font.Bold = true;
		xlsheet.Cells(StartRow+AddRow,1).Font.Size = 14;
		xlsheet.cells(StartRow+AddRow,4).Value=CurPatArr[1];
		if (CurPatArr[2]=="Y") {xlsheet.cells(StartRow+AddRow,10).Value="医生签名:";}
		var SignNameFlag=CurPatArr[3];
		if (PatItemInfo!="")
		{
			var ItemArr=PatItemInfo.split(Char_3);
			var ItemLength=ItemArr.length;
			var TotalRow=Math.ceil(ItemLength/RowNum) 
			for (var j=0;j<TotalRow;j++)
			{
				AddRow=AddRow+1;
				for (var k=0;k<5;k++)
				{
					var Num=j*5+k
					if (Num==ItemLength) break;
					var OneItem=ItemArr[Num];
					var OneItemArr=OneItem.split("^");
					xlsheet.cells(StartRow+AddRow,(k+1)*2).Value=OneItemArr[0];
					//如果是加项，字体加下划线
					if (OneItemArr[1]=="1")
					{
						xlsheet.cells(StartRow+AddRow,(k+1)*2).Font.Underline = true;
					}
				}
			}
			//AddRow=AddRow+1;
		}
		if (SignNameFlag=="Y") AddRow=AddRow+1;
		//xlsheet.Cells(AddRow,1).Borders.Weight = 1;
		//画下面边框粗线
		xlsheet.Range(xlsheet.cells(StartRow+AddRow,1),xlsheet.cells(StartRow+AddRow,11)).BorderS(4).LineStyle=7
		AddRow=AddRow+1
	}
	
	
	//xlsheet.printout
	xlsheet.saveas("d:\\aa.xls")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
	idTmr = window.setInterval("Cleanup();",1);

}

function PrintA4(value,PrintFlag,viewmark)  //友谊
{    
	//alert("PF"+PrintFlag)
	PrintExcel(value,PrintFlag,viewmark);
	return false;
	var obj=document.getElementById("HospitalCode")
	if(obj){var HospitalCode=obj.value}
	var TxtInfo="",ListInfo="";
	var Char_2=String.fromCharCode(2);
	var vals=value.split("#");
	// 患者信息
	PatInfos=vals[0].split(";");
	
	var PatTag=PatInfos[0].split("^"); // 标签
	var PatInf=PatInfos[1].split("^"); // 值

	for (var iLLoop=0;iLLoop<PatTag.length;iLLoop++){
		TxtInfo=TxtInfo+PatTag[iLLoop]+Char_2+PatInf[iLLoop]+"^";
	}	
	// 检验项目
	ListInfo="";
	var OEItems=vals[1].split(";");
	
   var pageItemCount=30;
	var ShortLine="____________";
	var NullLine="        ";

	var Line1="_____________________________________________"
    var Line2="________________________________"
	var Line3=""
	var LineStr="";
	var Line4="____________"
	var Line5="_____"
	var Line6="_____"
	var TotalPage=Math.ceil(OEItems.length/pageItemCount)
	var CurPage=0;
	for (var iLLoop=0;iLLoop<OEItems.length-1;iLLoop++){
		OEItem=OEItems[iLLoop].split("^");
		if (""!=OEItem[0]) var ItemName=OEItem[0]
		if (OEItem[0]==""){LineStr=NullLine+"^"+Line6+"^"+Line1+"^"+Line2+"^"+Line3+"^"+Line4+"^"+Line5;}
		if (OEItem[0]!=""){LineStr=ShortLine+"^"+Line6+"^"+Line1+"^"+Line2+"^"+Line3+"^"+Line4+"^"+Line5;}
		if (iLLoop!=OEItems.length-1)
		{
			var NextItem=OEItems[iLLoop+1].split("^")[0];
			if (NextItem!=""){LineStr=ShortLine+"^"+Line6+"^"+Line1+"^"+Line2+"^"+Line3+"^"+Line4+"^"+Line5;}
			if (NextItem==""){LineStr=NullLine+"^"+Line6+"^"+Line1+"^"+Line2+"^"+Line3+"^"+Line4+"^"+Line5;}
			if (iLLoop==OEItems.length-2) {LineStr=ShortLine+"^"+Line6+"^"+Line1+"^"+Line2+"^"+Line3+"^"+Line4+"^"+Line5;}
			if (OEItem[4]==OEItems[iLLoop+1].split("^")[4]){LineStr="^^^^^^";}
		}
		if (0==(iLLoop+1) % pageItemCount) {LineStr="^^^^^^";}   //如果是本页最后以行去掉横线
		if (1==(iLLoop+1) % pageItemCount) {OEItem[0]=ItemName;} //如果是后续页打印出来类别与流程
		if (OEItem[5]==1) OEItem[5]=""
		 				 // 横线	      类别流程 1	项目 2	  价格  	注意事项 3   执行标志
		ListInfo=ListInfo+LineStr+"^"+OEItem[0]+"^^"+OEItem[1]+"^"+OEItem[2]+"^^^"+OEItem[6]+OEItem[5]+Char_2;  //
		
		//分页 每页24行
		if ((0==(iLLoop+1) % pageItemCount)) {
			var myobj=document.getElementById("ClsBillPrint");
			CurPage=CurPage+1;
			var Info=TxtInfo+"PageInfo"+Char_2+"第"+CurPage+"页 (共"+TotalPage+"页)"
			//DHCP_PrintFunHDLP(myobj,Info,ListInfo);
			DHCP_PrintFun(myobj,TxtInfo,ListInfo);
			//if (!DHCP_PrintFun(myobj,TxtInfo,ListInfo)) return false;
			//alert(ListInfo);
			ListInfo="";
		}
	}

	if (ListInfo!=""){	var myobj=document.getElementById("ClsBillPrint");
	CurPage=CurPage+1;
	var Info=TxtInfo+"PageInfo"+Char_2+"第"+CurPage+"页 (共"+TotalPage+"页)"
	//if (!DHCP_PrintFunHDLP(myobj,Info,ListInfo)) return false;}
	if (!DHCP_PrintFun(myobj,TxtInfo,ListInfo)) return false;}



}
/* A4纸型 */
function PrintA4Old(value)
{	
	var TxtInfo="",ListInfo="";
	var Char_2=String.fromCharCode(2);
	var vals=value.split("#");
	
	// 患者信息
	PatInfos=vals[0].split(";");
	
	var PatTag=PatInfos[0].split("^"); // 标签
	var PatInf=PatInfos[1].split("^"); // 值

	for (var iLLoop=0;iLLoop<PatTag.length;iLLoop++){
		TxtInfo=TxtInfo+PatTag[iLLoop]+Char_2+PatInf[iLLoop]+"^";
	}	
	// 检验项目
	ListInfo="";
	var OEItems=vals[1].split(";");
	var ShortLine="______________";
	var NullLine="              ";
	var Line1="_____________________________________________"
	var Line2="______________________";
	var Line3="________"
	var LineStr="";
	for (var iLLoop=0;iLLoop<OEItems.length-1;iLLoop++){
		OEItem=OEItems[iLLoop].split("^");
if (""!=OEItem[0]) var ItemName=OEItem[0]
		
		if (OEItem[0]==""){LineStr=NullLine+"^"+Line1+"^"+Line2+"^"+Line3;}
		if (OEItem[0]!=""){LineStr=ShortLine+"^"+Line1+"^"+Line2+"^"+Line3;}
		if (iLLoop!=OEItems.length-1)
		{
			var NextItem=OEItems[iLLoop+1].split("^")[0];
			if (NextItem!=""){LineStr=ShortLine+"^"+Line1+"^"+Line2+"^"+Line3;}
			if (NextItem==""){LineStr=NullLine+"^"+Line1+"^"+Line2+"^"+Line3;}
			if (OEItem[4]==OEItems[iLLoop+1].split("^")[4]){LineStr="^^^";}
		}
		if (0==(iLLoop+1) % 33) {LineStr="^^^";}   //如果是本页最后以行去掉横线
		if (1==(iLLoop+1) % 33) {OEItem[0]=ItemName;} //如果是后续页打印出来类别与流程
		 				 // 横线	      类别流程 1	项目 2		注意事项 3
		ListInfo=ListInfo+LineStr+"^"+OEItem[0]+"^"+OEItem[1]+"^"+OEItem[2]+Char_2;  //
//分页 每页24行
		
		if ((0==(iLLoop+1) % 33)) {
			var myobj=document.getElementById("ClsBillPrint");
			DHCP_PrintFun(myobj,TxtInfo,ListInfo);
			//if (!DHCP_PrintFun(myobj,TxtInfo,ListInfo)) return false;
			//alert(ListInfo);
			ListInfo="";
		}
	}
	if (ListInfo!=""){	var myobj=document.getElementById("ClsBillPrint");
	if (!DHCP_PrintFun(myobj,TxtInfo,ListInfo)) return false;}

}
function PrintA5YY(value)

{	
   var obj=document.getElementById("HospitalCode")
	if(obj){var HospitalCode=obj.value}
	var TxtInfo="",ListInfo="";
	var Char_2=String.fromCharCode(2);
	var vals=value.split("#");
	
	// 患者信息
	PatInfos=vals[0].split(";");
	
	var PatTag=PatInfos[0].split("^"); // 标签
	var PatInf=PatInfos[1].split("^"); // 值

	for (var iLLoop=0;iLLoop<PatTag.length;iLLoop++){
		TxtInfo=TxtInfo+PatTag[iLLoop]+Char_2+PatInf[iLLoop]+"^";
	}	
	// 检验项目
	ListInfo="";
	var OEItems=vals[1].split(";");
  
	 
	var ShortLine="_______";
	var NullLine="       ";
	var Line1="________________________________________"
    var Line2="__________________"
	var Line3="_______"
	var LineStr="";
	var Line4="___"
	for (var iLLoop=0;iLLoop<OEItems.length-1;iLLoop++){
		OEItem=OEItems[iLLoop].split("^");
		if (""!=OEItem[0]) var ItemName=OEItem[0]
		
		if (OEItem[0]==""){LineStr=NullLine+"^"+Line4+"^"+Line1+"^"+Line2+"^"+Line3;}
		if (OEItem[0]!=""){LineStr=ShortLine+"^"+Line4+"^"+Line1+"^"+Line2+"^"+Line3;}
		if (iLLoop!=OEItems.length-1)
		{
			var NextItem=OEItems[iLLoop+1].split("^")[0];
			if (NextItem!=""){LineStr=ShortLine+"^"+Line4+"^"+Line1+"^"+Line2+"^"+Line3;}
			if (NextItem==""){LineStr=NullLine+"^"+Line4+"^"+Line1+"^"+Line2+"^"+Line3;}
			if (OEItem[4]==OEItems[iLLoop+1].split("^")[4]){LineStr="^^^^";}
		}
		if (0==(iLLoop+1) % 31) {LineStr="^^^^";}   //如果是本页最后以行去掉横线
		if (1==(iLLoop+1) % 31) {OEItem[0]=ItemName;} //如果是后续页打印出来类别与流程
		 				 // 横线	      类别流程 1	项目 2		注意事项 3
		 				 	 				 
		ListInfo=ListInfo+LineStr+"^"+OEItem[0]+"^"+OEItem[1]+"^"+OEItem[2]+Char_2;  //
		var EndFlag="N"
		if(iLLoop==OEItems.length-2)
		{   
           var EndFlag="Y"
           }
    
        if(EndFlag=="Y") 
        {
	      for (var EndiLoop=0;EndiLoop<3;EndiLoop++)
	      { iLLoop=iLLoop+1
	        ListInfo=ListInfo+"^^"+Line1+"^^"+"^^^"+Char_2
		    if ((0==(iLLoop+1) % 30)) {
			var myobj=document.getElementById("ClsBillPrint");
			DHCP_PrintFun(myobj,TxtInfo,ListInfo);
			ListInfo="";}
		}
        }
       	if ((0==(iLLoop+1) % 31)) {
			var myobj=document.getElementById("ClsBillPrint");
			DHCP_PrintFun(myobj,TxtInfo,ListInfo);
			ListInfo="";
		} 
	}

	if (ListInfo!=""){	var myobj=document.getElementById("ClsBillPrint");
	if (!DHCP_PrintFun(myobj,TxtInfo,ListInfo)) return false;}

}

//打印检查申请单
function PrintRisRequestApp(PADM,crmOrder,Type)
{   
	if (PADM==""){
		$.messager.alert("提示","请选择人员！","info");
		return false;
	}
	var encmeth="";
	var obj=document.getElementById("GetRisPrintInfo")
	if (obj) encmeth=obj.value;
	if (encmeth==""){
		var value=tkMakeServerCall("web.DHCPE.RisRequestPrint","GetRisRequestInfo",PADM,crmOrder,Type);
	}else{
		var value=cspRunServerMethod(encmeth,PADM,crmOrder,Type);
	}
	if (value=="") return;
	var char_1=String.fromCharCode(1);

	var char_2=String.fromCharCode(2);

	var arr1=value.split(char_1);
	var parInfo=arr1[0];
	var patientInfo=arr1[1];
	var orderInfo=arr1[2];
	var parArr=parInfo.split("^");
	var patientArr=patientInfo.split("^");
	var patientlength=patientArr.length;
	var PatientTxtInfo="";
	for (var iLLoop=0;iLLoop<patientlength;iLLoop++){
		PatientTxtInfo=PatientTxtInfo+parArr[iLLoop]+char_2+patientArr[iLLoop]+"^";
		//alert("PatientTxtInfo"+PatientTxtInfo)
	}
	var orderArr=orderInfo.split(char_2);
	var orderLength=orderArr.length;
	var myobj=document.getElementById("ClsBillPrint");
	for (var iLLoop=0;iLLoop<orderLength;iLLoop++){
		oneOrder=orderArr[iLLoop];
		oneOrderArr=oneOrder.split("^");
		var oneLength=oneOrderArr.length;
		var tempName=oneOrderArr[0];
		var TxtInfo=PatientTxtInfo;
		for (var i=1;i<oneLength;i++){
			TxtInfo=TxtInfo+parArr[patientlength+i-1]+char_2+oneOrderArr[i]+"^";
		
		}
		DHCP_GetXMLConfig("InvPrintEncrypt",tempName);
		//DHCP_PrintFun(myobj,TxtInfo,"");
		
		DHC_PrintByLodop(getLodop(),TxtInfo,"","", "");
	}
	
}
function PrintReportRJApp(PADM,Type)
{
	if (PADM==""){
		alert("没有选中打印人员");
		return false;
	}
	var obj;
	
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEReportRZ.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	var encmeth="";
	var obj=document.getElementById("GetReportInfo");
	if (obj) encmeth=obj.value;
	if (encmeth==""){
		alert("没有设置获取数据的方法");
		return false;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	var info=cspRunServerMethod(encmeth,PADM,Type);
	//RegNo_"^"_CardNo_"^"_Name_"^"_Sex_"^"_Age_"^"_InLoc_"^"_patType_"^"_address_"^"_TelNo_"^"_AppDate_"^"_HopeDate_"^"_Code_"^"_Married_"^"_Componey_"^"_Vocation_"^"_Nation_"^"_"体检"
	var infoArr=info.split("^");
	var regno=infoArr[0];
	xlsheet.PageSetup.RightHeader=regno;
	try
	{
	var msoShaoeRectangle = 1;//AddShape(透明度左上宽度高度) 
	xlsheet.Shapes.AddShape(msoShaoeRectangle, 387, 13, 78, 116).Fill.UserPicture("D:\\DHCPE\\"+regno+".bmp"); 
	//xlsheet.Shapes.AddShape(msoShaoeRectangle, 427, 29, 84, 130).Fill.UserPicture("D:\\DHCPE\\"+regno+".bmp"); 
	}
	catch(e)
	{
		//alert(e+"^"+e.message);
	}
	xlsheet.cells(2,3).Value=infoArr[2];
	xlsheet.cells(2,7).Value=infoArr[3];
	xlsheet.cells(2,10).Value=infoArr[4];
	xlsheet.cells(3,3).Value="";
	xlsheet.cells(3,7).Value=infoArr[15];
	xlsheet.cells(3,10).Value=infoArr[14];
	xlsheet.cells(3,13).Value=infoArr[12];
	xlsheet.cells(4,3).Value="";
	//xlsheet.cells(4,7).Value=infoArr[7];
	xlsheet.cells(4,8).Value=infoArr[7];
	xlsheet.cells(5,3).Value=infoArr[13];
	//xlsheet.saveas("d:\\aa.xls")
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
	
}
function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}
function PrintTarItemDetailApp(PADM,Type)
{
	if (PADM==""){
		alert("没有选中打印人员");
		return false;
	}
	var obj;
	
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPETarIemDetail.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	var info=tkMakeServerCall("web.DHCPE.PreIADM","GetTarItemInfo",PADM,Type);
	var Char_2=String.fromCharCode(2);
	var Char_1=String.fromCharCode(1);
	var infoArr=info.split(Char_2);
	var baseInfo=infoArr[0];
	var tarItemInfo=infoArr[1];
	var baseArr=baseInfo.split("^");
	xlsheet.cells(2,1).Value=xlsheet.cells(2,1).Value+baseArr[0];
	xlsheet.cells(2,4).Value=xlsheet.cells(2,4).Value+baseArr[1];
	tarItemArr=tarItemInfo.split(Char_1);
	var i=tarItemArr.length;
	for (var iLLoop=0;iLLoop<i;iLLoop++){
		oneTarItem=tarItemArr[iLLoop];
		oneArr=oneTarItem.split("^");
		xlsheet.cells(4+iLLoop,1).value=oneArr[0];
		xlsheet.cells(4+iLLoop,2).value=oneArr[1];
		xlsheet.cells(4+iLLoop,3).value=oneArr[2];
		xlsheet.cells(4+iLLoop,4).value=oneArr[3];
		xlsheet.cells(4+iLLoop,5).value=oneArr[4];
		xlsheet.cells(4+iLLoop,6).value=oneArr[5];
	}
	//xlsheet.saveas("d:\\aa.xls")
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
	
}