 document.body.onload=BodyLoadHandler;
function BodyLoadHandler(){ 
	var obj=document.getElementById('Export');
	if(obj){  obj.onclick=ExportClickHandler;}
}
function ExportClickHandler(){
	try{
		var pathObj=document.getElementById('getpath');
		if (pathObj) {var encmeth=pathObj.value} else {var encmeth=''};
		var path=cspRunServerMethod(encmeth)
		var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
	    var Template
	    var Template=path+"DHCAntUnAnditApp.xls"
	    	
	    xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet ; 
		
		var tid=document.getElementById("Tidz1").value
		var Obj=document.getElementById('GetDetail24hNum')
		if(Obj){ var encmeth=Obj.value} else{ var encmeth=''};
		var AntUseInfoNum=cspRunServerMethod(encmeth,tid);
		if (AntUseInfoNum==""){
			alert("没有数据可以导出");
			return;
			}
		//xlsheet.Cells(4,3)="开始日期"
		//var obj=document.getElementById('StDate'); //查询开始日期
		//if (obj){xlsheet.Cells(4,4)=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0];}
		//var obj=document.getElementById('EndDate');  //查询结束日期
		//xlsheet.Cells(4,7)="结束日期"
		//if (obj){xlsheet.Cells(4,8)=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0];}
		
		xlsheet.cells(2,1)="医嘱项"
		xlsheet.cells(2,2)="管制分类"
		xlsheet.cells(2,3)="申请医生"
		xlsheet.cells(2,4)="申请科室"
		xlsheet.cells(2,5)="申请时间"
		xlsheet.cells(2,6)="申请状态"
		xlsheet.cells(2,7)="登记号"
		xlsheet.cells(2,8)="病人姓名"
		xlsheet.cells(2,9)="用法"
		xlsheet.cells(2,10)="频率"
		xlsheet.cells(2,11)="疗程"
		xlsheet.cells(2,12)="使用目的"
		xlsheet.cells(2,13)="是否紧急"
		xlsheet.cells(2,14)="是否已超24小时"
		
		for (var i=1;i<=AntUseInfoNum;i++){
			var Obj=document.getElementById('GetDetail24h')
			if(Obj){ var encmeth=Obj.value} else{ var encmeth=''};
			var DataDetailArr=cspRunServerMethod(encmeth,tid,i);
			
			var Detail=DataDetailArr.split("^");
			var len=Detail.length;
			for(var j=0;j<len;j++){
				xlsheet.cells(2+i,j+1)=Detail[j];
				}
		}
		
		var ExTimeOBJ=new Date();
		//var ExTime=ExTimeOBJ.toLocaleString();
		//var ExTime=ExTime.replace(/\s/ig,'');
		
		var month=ExTimeOBJ.getMonth()+1;       //获取当前月份(0-11,0代表1月)
		var date=ExTimeOBJ.getDate();        //获取当前日(1-31)
		var hour=ExTimeOBJ.getHours();       //获取当前小时数(0-23)
		var minute=ExTimeOBJ.getMinutes();     //获取当前分钟数(0-59)
		var sec=ExTimeOBJ.getSeconds();     //获取当前秒数(0-59)
		var ExTime=month+"月"+date+"日"+hour+"时"+minute+"分"+sec+"秒"
		//xlApp.Visible=true;
		//xlsheet.PrintPreview();
		var Expath="C:\\抗菌药物使用情况报表"+ExTime+".xls";
		xlsheet.SaveAs(Expath);      
		xlBook.Close(savechanges=true);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
		alert("导出完成!\n\n文件位置："+Expath);
	}catch(e){
	     alert(e.message);
	     return;
	}
}