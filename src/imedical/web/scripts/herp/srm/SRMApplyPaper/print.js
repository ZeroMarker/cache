//打印程序添加说明
//MethodGetServer s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMedBaseCtl.GetServerInfo"))
//MethodGetData   s val=##Class(%CSP.Page).Encrypt($LB("类方法"))
//DHC.WMR.CommonFunction.js,DHC.WMR.ExcelPrint.JS,
//btnPrint  打印  websys/print_compile.gif
//btnExport 打印  websys/print_compile.gif
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

function ExportDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments)
{
try {
	xls = new ActiveXObject ("Excel.Application");
	Ext.Ajax.request({
		url :'herp.srm.srmapplypaperexe.csp' + '?action=getpath',
		failure : function(result, request) {
			Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
		},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var TemplatePath=GetWebConfig(jsonData.info).Path;
				var FileName=TemplatePath+"\\\\"+"SRMApplyPaper.xls";
				//var FileName="D:\DtHealth\app\dthis\med\Results\Template\SRMApplyPaper.xls";
				Ext.Ajax.request({
					url :'herp.srm.srmapplypaperexe.csp' + '?action=export&rowid='+strArguments+'&itmjs='+'fillxlSheet',
					waitMsg : '导出中...',
					failure : function(result, request) {
						Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					},
					success : function(result,request) {
						//var jsonData = Ext.util.JSON.decode(result.responseText);
						
							var FileName=TemplatePath+"\\\\"+"SRMApplyPaper.xls";							

			    xls.visible=false;
	            xlBook=xls.Workbooks.Add(FileName);
	            xlSheet=xlBook.Worksheets.Item(1);
				//alert(result);
				var flg=result.responseText;
				//alert(flg);
				eval(flg); //执行变量里的命令用eval函数
				/**
				fillxlSheet(xlSheet,'31-131',2,1);
                fillxlSheet(xlSheet,'王志',2,2);
                fillxlSheet(xlSheet,'本部药品调剂科',2,3);
                fillxlSheet(xlSheet,'药剂岗位',2,4);
                fillxlSheet(xlSheet,'副主任药师',2,5);
				**/
			    var fname = xls.Application.GetSaveAsFilename("***-论文投稿推荐函","Excel Spreadsheets (*.xls), *.xls");
	            xlBook.SaveAs(fname);
	            xlSheet=null;
	            xlBook.Close (savechanges=true);
	            xls.Quit();
	            xlSheet=null;
	            xlBook=null;
	            xls=null;
	            idTmr=window.setInterval("Cleanup();",1);
	            return true;
						
					},
					scope : this
				});
			}
		},
		scope : this
	});
}catch(e) {
		alert("创建Excel应用对象失败!");
		return false;
	}
	
		return true;
}
/*
function ExportDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments)
{	
		var objApplyPaper = ExtTool.StaticServerObject("herp.srm.udata.uSRMApplyPaper");
		var ServerInfo=objApplyPaper.GetServerInfo();
		var TemplatePath=GetWebConfig(ServerInfo).Path;
		var FileName=TemplatePath+"\\\\"+"SRMApplyPaper.xls";
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			alert("创建Excel应用对象失败!");
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg=objApplyPaper.Print("fillxlSheet",strArguments);
		//var flg=cspRunServerMethod(strMethod,"fillxlSheet",strArguments);
		var fname = xls.Application.GetSaveAsFilename(strTemplateName,"Excel Spreadsheets (*.xls), *.xls");
		xlBook.SaveAs(fname);
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);

	return true;
}
*/
/* 
function PrintDataToExcel(strMethodGetServer,strMethodGetData,strTemplateName,strArguments)
{
	try {	
		xls = new ActiveXObject ("Excel.Application");
		var objApplyPaper = ExtTool.StaticServerObject("herp.srm.udata.uSRMApplyPaper");
		var ServerInfo=objApplyPaper.GetServerInfo();
		var TemplatePath=GetWebConfig(ServerInfo).Path;
		var FileName=TemplatePath+"\\\\"+"SRMApplyPaper.xls";
		//var FileName="http://127.0.0.1/dthealth/app/dthis/med/Results/Template/SRMApplyPaper.xls";
		alert(FileName);
		xls.visible=true;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg=objApplyPaper.Print("fillxlSheet",strArguments);
		
		xlSheet.printout();
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
    }catch(e) {
			alert("创建Excel应用对象失败!");
			return false;
	}
	return true;
} */

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