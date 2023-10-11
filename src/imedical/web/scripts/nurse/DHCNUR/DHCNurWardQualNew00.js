var QualStr=""
function BodyLoadHandler(){
	
	QualStr=tkMakeServerCall("web.DHCMgQualCheck","getUnCheckCode",CheckRoomId,EmrCode);
//  alert(QualStr)
 setsize("mygridpl", "gform", "mygrid",0);
 var but1=Ext.getCmp('mygridbut1');
 but1.setText('确定');
 but1.on('click',funSure);
 var but2=Ext.getCmp('mygridbut2');
 but2.setText('打印');
 but2.on('click',Print);
 //alert("CheckRoomId|"+CheckRoomId+"^EmrCode|"+EmrCode)
 var tbar=Ext.getCmp('mygrid').getTopToolbar();
 //alert(tbar)
 //tobar=grid.getTopToolbar();
 var mygrid = Ext.getCmp("mygrid");
 mygrid.store.on("beforeLoad",function(){
 	//var mygrid = Ext.getCmp("mygrid");
  mygrid.store.baseParams.CheckQual=CheckRoomId;
 });
 SchQual();
 rowCalculate();
}
function funSure()
{
	var grid = Ext.getCmp('mygrid');
	var rowObj = grid.getSelectionModel().getSelections();
	//alert(rowObj)
	//debugger;
	if(rowObj.length==0){
		alert("请选择要保存的行！");
		return;
	}
	var CheckDate="";
	//var CheckWar="";DHCNurQualWardCountSum
	var CheckTyp="";
	if (CheckRoomId!=""){
		var getVal = document.getElementById('getVal2');
	  var ret=cspRunServerMethod(getVal.value,CheckRoomId);
    //alert(ret)
    var ha = new Hashtable();
      var tm=ret.split('^')
	    sethashvalue(ha,tm)
	    //alert(ha.items("CheckStDate"))  
   	 CheckDate=ha.items("CheckStDate");
	}
	var CheckUser=session['LOGON.USERID'];
  var CheckTyp="MasterNur";
  var CheckModel="QUAL41|QUAL13|QUAL42|QUAL16|QUAL17|QUAL43";
  var CheckModel2="QUAL20|QUAL21|QUAL22";
  var CheckWard =rowObj[0].get("loc");
  //alert(CheckWard)
  var CheckPat="";
  var CheckPar="";
  var CheckSun=CheckModel.split("|");
  if (CheckSun!=""){
  	for (var i=0;i<CheckSun.length;i++){
  		var CheckCode=CheckSun[i];
  		//alert(CheckCode);
  		var CheckScore=rowObj[0].get(CheckSun[i]);
  		//alert(CheckScore)
  		if(CheckScore!=""){
  			var SaveQual = document.getElementById('SaveQual');
  			//alert(CheckDate+"&"+CheckUser+"&"+CheckTyp+"&"+CheckCode+"&"+CheckWard+"&"+CheckScore+"&"+""+"&"+CheckPat+"&"+CheckPar+"&"+CheckRoomId)
  			var  CheckPar1=cspRunServerMethod(SaveQual.value,CheckDate,CheckUser,
  			CheckTyp,CheckCode,CheckWard,CheckScore,"",CheckPat,CheckPar,CheckRoomId);
  		}
  	}
  }
  var chPerformance=CheckModel2.split("|");
  if(chPerformance!=""){
  	for(var j=0;j<chPerformance.length;j++){
  		var checkPerCode=chPerformance[j];
  		var checkPerScore=rowObj[0].get(chPerformance[j]);
  		if(checkPerScore){
  			var SaveQual = document.getElementById('SaveQual');
  			var CheckPar2=cspRunServerMethod(SaveQual.value,CheckDate,CheckUser,
  			CheckTyp,checkPerCode,CheckWard,checkPerScore,"",CheckPat,CheckPar,CheckRoomId)
  		}
  	}
  }
  
  SchQual();
  
}
function rowCalculate()
{
	var mygrid=Ext.getCmp('mygrid');
	//alert(mygrid.getStore())
	//alert(mygrid.getView().getRows().length)
	var n = mygrid.getStore().getCount();
	//var m=mygrid.getView().getRows();
	//debugger;
	var gridcount=0;
	mygrid.getStore().each(function(r){
		//alert(r)
		gridcount=gridcount+1;
		alert(gridcount)
	})
}
function handleGridLoadEvent(store,records)
{
	var grid=Ext.getCmp('mygrid');
	
	var gridcount=0;
	store.each(function(r){
		//alert(grid.getView().getRow(gridcount))
		//debugger;
		//var score=r.get('QUAL35')
		var arrMarry="QUAL35|QUAL8|QUAL4|QUAL6|QUAL7|QUAL1|QUAL36|QUAL38|QUAL5|QUAL10|QUAL40|QUAL39|QUAL37|item9|QUAL41|QUAL13|QUAL42|QUAL16|QUAL17";
		//QUAL8-QUAL4-QUAL6-QUAL7-QUAL1-QUAL36-QUAL38-QUAL5-QUAL10-QUAL40-QUAL39-QUAL37-item9-Qual41-Qual42-Qual16-Qual17
		var arrLen=arrMarry.split('|').length;
		//alert(arrLen)
		var sum=100;
		for(var i=0;i<arrLen;i++){
			//debugger
			if(r.get(arrMarry.split('|')[i])){
				sum=parseFloat(sum)+parseFloat(r.get(arrMarry.split('|')[i]));
//				r.commit(r.set("QUAL18",sum));
//				r.commit(r.set("QUAL19",(sum*0.08).toFixed(2)));
				//grid.getStore().getAt(gridcount).data.QUAL18=sum;
				//alert(grid.getStore().getAt(gridcount).data.QUAL18)
//				grid.getView().getCell(gridcount,20).innerText=sum
//				grid.getView().getCell(gridcount,21).innerText=(parseFloat(sum)*0.08).toFixed(2);
			}else if(r.get(arrMarry.split('|')[i])==""){
				sum=parseFloat(sum);
			}
			r.commit(r.set("QUAL18",sum));
			r.commit(r.set("QUAL19",(sum*0.08).toFixed(2)));
		}
		var perForMarry="QUAL20|QUAL21|QUAL22";
		var perLen=perForMarry.split('|').length;
		var perSum=r.get('QUAL19');
		
		for(var j=0;j<perLen;j++){
			if(r.get(perForMarry.split('|')[j])){
				perSum=parseFloat(perSum)+parseFloat(r.get(perForMarry.split('|')[j]));
				r.commit(r.set("Cperf",perSum.toFixed(2)));
			}else{
				r.commit(r.set("Cperf",parseFloat(perSum).toFixed(2)));
			}
		}

		gridcount=gridcount+1;
	})
}
function SchQual()
{
	var mygrid = Ext.getCmp("mygrid");
	
	//mygrid.getStore().addListener('load',handleGridLoadEvent);
	mygrid.store.load({
		params : {
			start : 0,
			limit : 30
		}
	});
}
function Print1()
{
	var xls = new ActiveXObject ("Excel.Application"); 
	xls.visible =false;
	var xlBook = xls.Workbooks.Add; 
	var xlSheet = xlBook.Worksheets(1); 
	var grid = Ext.getCmp("mygrid"); 
	var cm = grid.getColumnModel(); 
	var colCount = cm.getColumnCount(); 
	//alert(cm)
	debugger
}
function Print()
{
	//alert('打印');
	//var QualStr="QUAL35^QUAL8^QUAL4^QUAL6^QUAL7^QUAL1^QUAL36^QUAL38^QUAL5^QUAL10^QUAL40^QUAL39^QUAL37^item9^QUAL41^QUAL13^QUAL42^QUAL16^QUAL17^QUAL18^QUAL19^QUAL20^QUAL21^QUAL22^Cperf"
	var val=tkMakeServerCall("DHCMGNUR.MgCheckWard","getVal",CheckRoomId);
    //alert(CheckRoomId)
  var arr=val.split("^");
  //alert(arr);
  var ha = new Hashtable();
  
	//alert(val);
	 //alert(1)
	sethashvalue(ha, arr);
	var checktitle=ha.items("CheckTitle");
	var CheckStDate=ha.items("CheckStDate");
	//alert(CheckStDate)
	var titleName=CheckStDate.split('-')[0]+"年"+CheckStDate.split('-')[1]+"月"+"护理质控检查结果（病房）";
	
  PrintComm.TitleStr="CheckTitle@"+titleName;
  //PrintComm.QualStr=QualStr;
	//alert(PrintComm.QualStr)
  PrintComm.RHeadCaption="";
 
  //debugger;
  PrintComm.SetPreView("1");
  //PrintComm.PrnLoc=session['LOGON.CTLOCID'];
  PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
	PrintComm.ItmName="DHCNurWardQualNewPnt";
	PrintComm.ID = "";
	PrintComm.MultID = ""; 
	PrintComm.AllLine="N";
	PrintComm.SetParrm(CheckRoomId);
	PrintComm.PrintOut();
	
	
}
//function exportFn(){
//	var xls = new ActiveXObject ("Excel.Application"); 
//	xls.visible =true;  //设置excel为可见 
//	var xlBook = xls.Workbooks.Add; 
//	var xlSheet = xlBook.Worksheets(1); 
//	//var grid = Ext.getCmp('ApplyRecordGrid');
//  var grid = Ext.getCmp("mygrid");
// 	var cm = grid.getColumnModel(); 
//	var colCount = cm.getColumnCount(); 
//	var temp_obj = []; 
//	//只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示) 
//	//临时数组,存放所有当前显示列的下标 
//	 for(i=0;i <colCount;i++){ 
//		if(cm.isHidden(i) == true){ 
//		}else{ 
//			temp_obj.push(i); 
//		} 
//	} 
//	for(i=1;i <=temp_obj.length;i++){ 
//		//显示列的列标题 
//		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i - 1]); 
//	} 
//	var store = grid.getStore(); 
//	var recordCount = store.getCount(); 
//	var view = grid.getView(); 
//	for(i=1;i <=recordCount;i++){ 
//		for(j=1;j <=temp_obj.length;j++){ 
//			//EXCEL数据从第二行开始,故row = i + 1; 
//			xlSheet.Cells(i + 1,j).Value = view.getCell(i - 1,temp_obj[j - 1]).innerText; 
//		} 
//	} 
//	xlSheet.Columns.AutoFit; 
//	xls.ActiveWindow.Zoom = 75 
//	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
//  xls=null; 
//  xlBook=null; 
//  xlSheet=null; 
//}