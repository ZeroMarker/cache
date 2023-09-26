/*!
 *@creator:yunhaibao
 *@createdate:2016-08-30
 *@description:药房的打印相关方法
 *@others:注,仅前台处理,不掉后台
 */
 
/* excel start*/ 
	//清空XLS对象
	function SetNothing(app,book,sheet){
		app=null;
		book.Close(savechanges=false);
		sheet=null;
	} 
	//合并单元格
	function mergcell(objSheet,row,c1,c2){
		objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).MergeCells =1;
	} 

	//划下边框线
	function setBottomLine(objSheet,row,startcol,colnum) {
		objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;
	}
	function cellEdgeRightLine(objSheet,row,c1,c2){
		for (var i=c1;i<=c2;i++){
			objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(10).LineStyle=1;
			objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(7).LineStyle=1;
		}
	}
	//指定区域的边框
	function cellEdgeLine(objSheet,row1,row2,c1,c2){
		objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
		objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
		objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
		objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1;
	}
/* excel end*/ 
//格式化日期
function FormatDate(datestr,sep){
	var dateobj=new Date(datestr.replace(/-/g,"/"));	
	var day=dateobj.getDate();
	var mon=dateobj.getMonth()+1;
	if (mon<10) mon="0"+mon ;
	var year=dateobj.getFullYear();
	var varyear=year.toString();
	return year+sep+mon+sep+day;
}
function getPrintDateTime(){	
	var d=new Date();
	var pt="";
	var c=":";
	var tmpdate	=d.getDate();
	var tmpmonth=d.getMonth()+1;
	if (tmpdate<10){
		tmpdate="0"+tmpdate;
	}
	if (tmpmonth<10){
		tmpmonth="0"+tmpmonth;
	}
	if(DHCPHA_CONSTANT.PLUGINS.DATEFMT=="DD/MM/YYYY"){
		pt+=tmpdate+"/";	
		pt+=tmpmonth+"/";
		pt+=d.getFullYear();
	}else if (DHCPHA_CONSTANT.PLUGINS.DATEFMT="YYYY-MM-DD"){
		pt+=d.getFullYear()+"-";	//getYear 改为 getFullYear 20151104zhouyg
		pt+=(d.getMonth()+1)+"-";
		pt+=tmpdate;
	}else{
		pt+=d.getFullYear()+"-";	
		pt+=tmpmonth+"-";
		pt+=tmpdate;
	} 
	pt+=" "
	pt+=d.getHours()+c;
	pt+=d.getMinutes()+c;
	pt+=d.getSeconds();
	return pt
}
function getPrintTime(){
	var d=new Date();
	var pt="";
	var c=":";	
	pt=d.getHours()+c;
	pt+=d.getMinutes()+c;
	pt+=d.getSeconds();
	return pt
}

