 document.body.onload=BodyLoadHandler;
function BodyLoadHandler(){
	var obj=document.getElementById("UnAudit")
	if(obj) obj.onclick=UnAuditClickHandler;
	var obj1=document.getElementById("Export")
	if(obj1) obj1.onclick=Export_Click;
	var obj2=document.getElementById("Prior")
	if(obj2) { 
		obj2.size=1;
		obj2.multiple=false;
		var GetOrderPriorStr=document.getElementById("GetOrderPriorStr").value;
		if(GetOrderPriorStr!="")  GetOrderPriorStr=cspRunServerMethod(GetOrderPriorStr)
		var PriorArr=GetOrderPriorStr.split("^")
		var len=PriorArr.length
		for (var i=0;i<len;i++){
			var PriorStr=PriorArr[i].split(String.fromCharCode(2))
			obj2.options[i]=new Option(PriorStr[1],PriorStr[0]);
			}
		obj2.onchange=OrderPriorSelected;
		if(document.getElementById("currentProir")){
			if (document.getElementById("currentProir").value) {
				//obj2.selectedIndex=document.getElementById("currentProir").value;
			}else{
				obj2.selectedIndex=0
			}
		}
	}
	var obj3=document.getElementById("OrderPoison")
	if(obj3){
		obj3.size=1;
		obj3.multiple=false;
		var GetOrderPoisonStr=document.getElementById("GetPHCPoisonMethod").value;
		if(GetOrderPoisonStr!="")  GetOrderPoisonStr=cspRunServerMethod(GetOrderPoisonStr)
		var PoisonArr=GetOrderPoisonStr.split("^")
		var len=PoisonArr.length
		for (var i=0;i<len;i++){
			var PoisonStr=PoisonArr[i].split(String.fromCharCode(2))
			obj3.options[i]=new Option(PoisonStr[1],PoisonStr[0]);
			}
		}
		obj3.onchange=PoisonList_OnChange;
		if(document.getElementById("currentPoison")){
			if (document.getElementById("currentPoison").value) {
				//obj3.selectedIndex=document.getElementById("currentPoison").value;
			}else{
				obj3.selectedIndex=0
			}
		}
	}
function OrderPriorSelected(){
	var Prior=document.getElementById("Prior")
	var PriorID=document.getElementById("PriorID")
	var selIndex=Prior.selectedIndex;
	if (selIndex==-1) {
		return;
		}else{
			Prior.options[selIndex].selected=true;
			PriorID.value=Prior.options[selIndex].value
			}
	$("currentProir").value=$("Prior").selectedIndex;	
	}
function PoisonList_OnChange(){
	$("currentPoison").value=$("OrderPoison").selectedIndex;
	}
function LookupLoc(value){
	var temp;
	temp=value.split("^");
	LocID=temp[1];
	document.getElementById("LocID").value=LocID;
	//update by shp 20150106
	document.getElementById("Loc").value=temp[0];
	}
function UnAuditClickHandler(){
	var LocID=document.getElementById("LocID").value;
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCAntUnAnditApp&LocID="+LocID;
	window.open(url,true,"status=1,scrollbars=1,top=50,left=10,width=1000,height=530,resizable=yes")
	}
function Export_Click(){
	//待修改
	try{
		var pathObj=document.getElementById('getpath');
		if (pathObj) {var encmeth=pathObj.value} else {var encmeth=''};
		var path=cspRunServerMethod(encmeth)
		
		var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
	    	var Template
	    	var Template=path+"AntUseInfoReport.xls"
	    	
	    	xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet ; 
		
		var tid=document.getElementById("Tidz1").value
		var Obj=document.getElementById('GetAntUseNum')
		if(Obj){ var encmeth=Obj.value} else{ var encmeth=''};
		var AntUseInfoNum=cspRunServerMethod(encmeth,tid);
		if (AntUseInfoNum==""){
			alert("没有数据可以导出");
			return;
			}
		xlsheet.Cells(4,3)="开始日期"
		var obj=document.getElementById('StDate'); //查询开始日期
		if (obj){xlsheet.Cells(4,4)=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0];}
		var obj=document.getElementById('EndDate');  //查询结束日期
		xlsheet.Cells(4,7)="结束日期"
		if (obj){xlsheet.Cells(4,8)=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0];}
		
		xlsheet.cells(5,1)="登记号"
		xlsheet.cells(5,2)="病人姓名"
		xlsheet.cells(5,3)="医嘱科室"
		xlsheet.cells(5,4)="医嘱名称"
		xlsheet.cells(5,5)="用法"
		xlsheet.cells(5,6)="频率"
		xlsheet.cells(5,7)="疗程"
		xlsheet.cells(5,8)="开医嘱医生"
		xlsheet.cells(5,9)="开医嘱时间"
		xlsheet.cells(5,10)="审核医嘱医生"
		xlsheet.cells(5,11)="审核医嘱时间"
		xlsheet.cells(5,12)="会诊科室"
		xlsheet.cells(5,13)="会诊医生"
		xlsheet.cells(5,14)="会诊时间"
		xlsheet.cells(5,15)="药品管制分类"
		xlsheet.cells(5,16)="用药使用目的"
		xlsheet.cells(5,17)="疗效"
		xlsheet.cells(5,18)="是否24小时审核"
		xlsheet.cells(5,19)="医嘱状态"
		xlsheet.cells(5,20)="会诊意见"
		xlsheet.cells(5,21)="医嘱类型"
		for (var i=1;i<=AntUseInfoNum;i++){
			var Obj=document.getElementById('GetAntUseDetail')
			if(Obj){ var encmeth=Obj.value} else{ var encmeth=''};
			var DataDetailArr=cspRunServerMethod(encmeth,tid,i);

			var Detail=DataDetailArr.split("^");
			xlsheet.cells(6+i,1)=Detail[0];
			xlsheet.cells(6+i,2)=Detail[1];
			xlsheet.cells(6+i,3)=Detail[2];
			xlsheet.cells(6+i,4)=Detail[3];
			xlsheet.cells(6+i,5)=Detail[4];
			xlsheet.cells(6+i,6)=Detail[5];
			xlsheet.cells(6+i,7)=Detail[6];
			xlsheet.cells(6+i,8)=Detail[7];
			xlsheet.cells(6+i,9)=Detail[8];
			xlsheet.cells(6+i,10)=Detail[9];
			xlsheet.cells(6+i,11)=Detail[10];
			xlsheet.cells(6+i,12)=Detail[11];
			xlsheet.cells(6+i,13)=Detail[12];
			xlsheet.cells(6+i,14)=Detail[13];
			xlsheet.cells(6+i,15)=Detail[14];
			xlsheet.cells(6+i,16)=Detail[15];
			xlsheet.cells(6+i,17)=Detail[16];
			xlsheet.cells(6+i,18)=Detail[17];
			xlsheet.cells(6+i,19)=Detail[18];
			xlsheet.cells(6+i,20)=Detail[19];
			xlsheet.cells(6+i,21)=Detail[20];
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
		var Expath="C:\\抗菌药物使用情况报表"+ExTime+".xls"
		xlApp.Visible=true;
		//xlsheet.PrintPreview();
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
