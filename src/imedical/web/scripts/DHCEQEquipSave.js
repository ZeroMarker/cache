//台帐保存
var num;
var job;

function  PrintDHCEQEquip(vData,SaveOrPrint)
{
	var job="";
	var obj=window.parent.frames[1].document.getElementById("Tjobz1");
	if(obj)
	{job=obj.innerText;}
	
	/// Modified by jdl 2013-7-16 JDL0133 优化台帐导出效率?增加参数每次获取行数信息100
	PrintDHCEQEquipNew("Equip",SaveOrPrint,job,vData,"",50);
	return;
	/*
	GetNum()
	if (num<=1) {alertShow("表没值")}
	else
	{
     try {
	    var FileName=GetFileName();
	    ///var FileName="d:\equip.xls";
	    if (FileName=="") {return;}
      	var GetPrescPath=document.getElementById("GetRepPath");
		if (GetPrescPath)
		 {
			 var encmeth=GetPrescPath.value
			 } 
		else 
		{
			var encmeth=''
			};
		if (encmeth!="") 
		{
			var	TemplatePath=cspRunServerMethod(encmeth);
			}
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQEquipSP.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet  
	    for (Row=1;Row<=num;Row++)
	    { 
	   		var list=document.getElementById('GetList');
		 	if (list) {var encmeth=list.value} else {var encmeth=''};
			var str=cspRunServerMethod(encmeth,'','',job,Row)
			var List=str.split("^")
			xlsheet.Rows(Row+1).Insert()
			xlsheet.cells(Row+1,1)=List[0]//设  备  名  称
			xlsheet.cells(Row+1,2)=List[1]; //机型
			xlsheet.cells(Row+1,3)=List[2]; //设备分类
			xlsheet.cells(Row+1,4)=List[3]; //设备单位
			xlsheet.cells(Row+1,5)=List[4]; //编码
			xlsheet.cells(Row+1,6)=List[5]; //描述
			xlsheet.cells(Row+1,7)=List[6]; //安装地点
			xlsheet.cells(Row+1,8)=FormatDate(List[7],"",""); //安装日期
			xlsheet.cells(Row+1,9)=List[8]; //出厂编号
			xlsheet.cells(Row+1,10)=FormatDate(List[9],"",""); //出厂日期
			xlsheet.cells(Row+1,11)=FormatDate(List[10],"",""); //开箱验收日期//验收日期
			xlsheet.cells(Row+1,12)=FormatDate(List[11],"",""); //制造日期
			xlsheet.cells(Row+1,13)=List[12]; //国别
			xlsheet.cells(Row+1,14)=List[13]; //使用部门
			xlsheet.cells(Row+1,15)=List[14]; //设备来源
			xlsheet.cells(Row+1,16)=List[15]; //设备来源部门
			xlsheet.cells(Row+1,17)=List[16]; //设备去向
			xlsheet.cells(Row+1,18)=List[17]; //采购方式
			xlsheet.cells(Row+1,19)=List[18]; //供应商
			xlsheet.cells(Row+1,20)=List[19]; //生产厂商
			xlsheet.cells(Row+1,21)=List[20]; //设备原值
			xlsheet.cells(Row+1,22)=List[21]; //设备净值
			xlsheet.cells(Row+1,23)=List[22]; //设备净残值
			xlsheet.cells(Row+1,24)=List[23]; //使用年限
			xlsheet.cells(Row+1,25)=List[24]; //合同
			xlsheet.cells(Row+1,26)=List[25]; //折旧方法
			xlsheet.cells(Row+1,27)=List[26]; //备注
			xlsheet.cells(Row+1,28)=List[27]; //累计折旧合计
			xlsheet.cells(Row+1,29)=List[28]; //额定工作总量
			xlsheet.cells(Row+1,30)=List[29]; //工作量单位
			xlsheet.cells(Row+1,31)=List[30]; //管理责任人
			xlsheet.cells(Row+1,32)=List[31]; //维修负责人
			xlsheet.cells(Row+1,33)=List[32]; //供方联系人
			xlsheet.cells(Row+1,34)=List[33]; //供方电话
			xlsheet.cells(Row+1,35)=List[34]; //附加费用合计
			xlsheet.cells(Row+1,36)=FormatDate(List[35],"",""); //起用日期
			xlsheet.cells(Row+1,37)=FormatDate(List[36],"",""); //转资日期
			xlsheet.cells(Row+1,38)=List[37]; //保修标志
			xlsheet.cells(Row+1,39)=List[38]; //科研
			xlsheet.cells(Row+1,40)=List[39]; //医疗设备
			xlsheet.cells(Row+1,41)=FormatDate(List[40],"",""); //保修开始日期
			xlsheet.cells(Row+1,42)=FormatDate(List[41],"",""); //保修结束日期
			xlsheet.cells(Row+1,43)=List[42]; //批标志
			xlsheet.cells(Row+1,44)=List[43]; //数量
			xlsheet.cells(Row+1,45)=List[44]; //助记码
			xlsheet.cells(Row+1,46)=List[45]; //急购
			xlsheet.cells(Row+1,47)=List[46]; //设备类型
			xlsheet.cells(Row+1,48)=List[47]; //申购类别
			xlsheet.cells(Row+1,49)=List[48]; //用途
			xlsheet.cells(Row+1,50)=List[49]; //保管人
			xlsheet.cells(Row+1,51)=List[50]; //设备库房
			xlsheet.cells(Row+1,52)=List[51]; //起折月份
			xlsheet.cells(Row+1,53)=List[52]; //售后服务商
			xlsheet.cells(Row+1,54)=List[53]; //入库明细
			xlsheet.cells(Row+1,55)=List[54]; //设备编号
			xlsheet.cells(Row+1,56)=List[55]; //状态
			xlsheet.cells(Row+1,57)=List[56]; //库房状态
			xlsheet.cells(Row+1,58)=List[57]; //服务联系人
			xlsheet.cells(Row+1,59)=List[58]; //服务电话
			xlsheet.cells(Row+1,60)=List[59];
			var Loc=List[51];
			////if (Row>10&&Row<15) alertShow(Loc);
			if (Loc!="")
			{
				///Loc=Loc.split("-");
				///xlsheet.cells(Row+1,61)=Loc[0];
				xlsheet.cells(Row+1,61)=List[60];
			}
			
	     }
	    xlBook.SaveAs(FileName);   //lgl+
	    //xlBook.SaveAs("D:\\cgeqipsq.xls");
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	   }
 
	catch(e)
	 {
		alertShow(e.message);
		};
	}*/
}
/// Mozy0103	20130716
function PrintDHCEQEquipToTXT()
{
	var TempNode="EquipList";
	GetNum(TempNode,"");
	if (num<=1)
	{
		alertShow("没有符合条件的数据!")
	}
	else
	{
		try
		{
			var FileName=GetFileNameToTXT();
			var fso = new ActiveXObject("Scripting.FileSystemObject");
    		var f = fso.OpenTextFile(FileName,2,true);	//覆盖写文件
    		encmeth=GetElementValue("GetColSets");
			var	colsets=cspRunServerMethod(encmeth,"","2","","Equip"); //用户级设置
			if (colsets=="")
			{
				var	colsets=cspRunServerMethod(encmeth,"","1","","Equip"); //安全组级设置
				if (colsets=="")
				{
					var	colsets=cspRunServerMethod(encmeth,"","0","","Equip"); //系统设置
				}
			}
			var colsetlist=colsets.split("&");
			var colname=new Array()
			var colcaption=new Array()
			var colposition=new Array()
			//var colformat=new Array()
			var cols=colsetlist.length
			for (i=0;i<cols;i++)
			{
				var colsetinfo=colsetlist[i].split("^");
				colcaption[i]=colsetinfo[1];
				//colname[i]=colsetinfo[2];
				colposition[i]=colsetinfo[3];
				//colformat[i]=colsetinfo[4];
			}
			//写入标题
		    var tmpString="";
		    for (i=0;i<cols;i++)
		    {
			    if (tmpString!="") tmpString=tmpString+"\t";
			    tmpString=tmpString+colcaption[i];
			}
			f.WriteLine(tmpString);
			//写入记录
			var EndRow=parseFloat(num)+1;
			for (Row=1;Row<=num;Row++)
		    { 
		   		var list=document.getElementById('GetList');
			 	if (list) {var encmeth=list.value} else {var encmeth=''};
				var str=cspRunServerMethod(encmeth,TempNode,job,Row);
				var List=str.split("^")			// 导出数据信息
				//alertShow("List="+List)
				tmpString="";
				for (i=1;i<=cols;i++)
		    	{
			    	var position=colposition[i-1];
			    	if (position>0)
			    	{	position=position-1;}
			    	else
			    	{	position=0}
			    	//if (Row==1) alertShow(position+"&"+List[position]);
			    	tmpString=tmpString+List[position].replace(/\r\n/g,"")+"\t";
				}
				f.WriteLine(tmpString);
		    }
		    f.Close();
			alertShow("导出完成!");
		} 
		catch(e)
		{
			alertShow(e.message);
		}
	}
}
