//DHCANOPCount.JS
var preRowInd=0;
function BodyLoadHandler(){
	var obj=document.getElementById('ADD');
	if(obj) 
	{
		obj.onclick=BADD_click;
	}
	var obj=document.getElementById('Update');
	if(obj) 
	{
		obj.onclick=BUpdate_click;
	}
	var obj=document.getElementById('Delete');
	if(obj)
	{ 
		obj.onclick=BDelete_click;
	}
	var obj=document.getElementById("btnPrint");
	if (obj)
	{	
		 obj.onclick=btnPrintClick;
	}
	var objtbl=document.getElementById('tDHCANOPCount');
	for (var i=1;i<objtbl.rows.length;i++)
	{
       	var	obj=document.getElementById('tPreOperNumz'+i);
       	if (obj) obj.onkeydown=UpdateKeyDown;
       	var	obj=document.getElementById('tAddNumz'+i);
       	if (obj) obj.onkeydown=UpdateKeyDown;
       	var	obj=document.getElementById('tUnSewNumz'+i);
       	if (obj) obj.onkeydown=UpdateKeyDown;
       	var	obj=document.getElementById('tSewedNumz'+i);
       	if (obj) obj.onkeydown=UpdateKeyDown;
	}
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANOPCount');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var objSelrow=document.getElementById("selrow");
    objSelrow.value=selectrow;
	if (!selectrow) return;
	var obj=document.getElementById('CountItemId');
	var obj1=document.getElementById('CountItem');
	var obj2=document.getElementById('PreOperNum');
	var obj3=document.getElementById('AddNum');
	var obj4=document.getElementById('UnSewNum');
	var obj5=document.getElementById('SewedNum');
	var obj6=document.getElementById('ANOPCId');
	var obj7=document.getElementById('SelfDefine');
	
	var SelRowObj=document.getElementById('OPCountIdz'+selectrow);
	var SelRowObj1=document.getElementById('OPCountDescz'+selectrow);
	var SelRowObj2=document.getElementById('tPreOperNumz'+selectrow);
	var SelRowObj3=document.getElementById('tAddNumz'+selectrow);
	var SelRowObj4=document.getElementById('tUnSewNumz'+selectrow);
	var SelRowObj5=document.getElementById('tSewedNumz'+selectrow);
	var SelRowObj6=document.getElementById('tANOPCIdz'+selectrow);
	var SelRowObj7=document.getElementById('tSelfDefinez'+selectrow);
	
	//alert(SelRowObj.value+" "+SelRowObj1.innerText+" "+SelRowObj2.value+" "+SelRowObj3.value+" "+SelRowObj4.value+" "+SelRowObj5.value+" "+SelRowObj6.value);
	if (preRowInd==selectrow){
	    obj.value="";
		obj1.value="";
		obj2.value="";
		obj3.value="";
		obj4.value="";
		obj5.value="";
		obj6.value="";
		if(obj7)
		  obj7.checked=false;
   		preRowInd=0;
    }
   	else{
		if (obj) obj.value=SelRowObj.value;
		if (obj1) obj1.value=SelRowObj1.innerText;
		if (obj2) obj2.value=SelRowObj2.value;
		if (obj3) obj3.value=SelRowObj3.value;
		if (obj4) obj4.value=SelRowObj4.value;
		if (obj5) obj5.value=SelRowObj5.value;
		if (obj6) obj6.value=SelRowObj6.value;
		if (obj7) {
			if (SelRowObj7.innerText=="Y") 	obj7.checked=true;
			else obj7.checked=false;
		}
		preRowInd=selectrow;
   }
   return;
}
function BADD_click()
{
	var CountItemId="",opaId="",PreOperNum="",AddNum="",UnSewNum="",SewedNum="",SelfDefine="N",Note="";
	var obj=document.getElementById('opaId');
	if(obj.value=="") 
	{
		alert("请选择一条手术");
		return;
		};
	opaId=obj.value;
	var obj=document.getElementById('CountItemId');
	if(obj) CountItemId=obj.value;
	var obj=document.getElementById('CountItem');
	if((obj)&&(obj.value=="")) CountItemId="";
	var obj=document.getElementById('SelfDefine');
	if ((obj)&&(obj.checked==true)) {
		SelfDefine="Y";
		var objCountItem=document.getElementById('CountItem');
		if (objCountItem) Note=objCountItem.value;
		if (Note=="") 
		{
			//alert(t['04']);
			alert("请填写自定义清点项目")
			return;
		}
	}
	if((CountItemId=="")&&(SelfDefine!="Y")){
		//alert(t['01']) 
		alert("清点项目不能为空");
		return;
	}
	var obj=document.getElementById('PreOperNum');
	if(obj) PreOperNum=obj.value;
	var obj=document.getElementById('AddNum');
	if(obj) AddNum=obj.value;
	var obj=document.getElementById('UnSewNum');
	if(obj) UnSewNum=obj.value;
	var obj=document.getElementById('SewedNum');
	if(obj) SewedNum=obj.value;	
	var obj=document.getElementById('RepCountItem')
	if(obj){ 
		var repflag=cspRunServerMethod(obj.value,CountItemId,opaId)
		if(repflag=="Y"){
			//alert(t['02'])
			alert("清点项目重复，无法添加");
			 return;
		}
	}
	
	var val = parseInt(PreOperNum) + parseInt(AddNum) - parseInt(UnSewNum);
    
    if(val !== 0)
    {
        alert("数目不平衡");
        return;
    }
	
	var obj=document.getElementById('AddCount')
	if(obj) {
		var ret=cspRunServerMethod(obj.value,CountItemId,opaId,"",PreOperNum,AddNum,UnSewNum,SewedNum,SelfDefine,Note);
	    if (ret!='0'){
		    //alert(t['baulk']);
		    alert("操作失败");
			return;
		}	
		try {
			//alert(t['succeed']);
			alert("操作成功");
		    window.location.reload();
		} catch(e) {};
	}
}
function BUpdate_click()
{
	if(preRowInd<1)return;
	var opaId="",ANOPCId="",CountItemId="",PreOperNum="",AddNum="",UnSewNum="",SewedNum="",SelfDefine="N",Note="";
	var obj=document.getElementById('opaId')
	if(obj) var opaId=obj.value;
	var obj=document.getElementById('ANOPCId')
	if(obj) var ANOPCId=obj.value;
	var obj=document.getElementById('CountItemId');
	if(obj) CountItemId=obj.value;
	var obj=document.getElementById('CountItem');
	if((obj)&&(obj.value=="")) CountItemId="";
	var obj=document.getElementById('SelfDefine');
	if ((obj)&&(obj.checked==true)) {
		SelfDefine="Y";
		var objCountItem=document.getElementById('CountItem');
		if (objCountItem) Note=objCountItem.value;
		if (Note=="") {alert(t['04']);return;}
	}
	if((CountItemId=="")&&(SelfDefine!="Y")){
		alert(t['01']) 
		return;
	}
	var selrow=document.getElementById("selrow").value;
	if (selrow=="") return;
	
	var obj=document.getElementById('PreOperNum');
	if(obj) PreOperNum=obj.value;
	var obj=document.getElementById('AddNum');
	if(obj) AddNum=obj.value;
	var obj=document.getElementById('UnSewNum');
	if(obj) UnSewNum=obj.value;
	var obj=document.getElementById('SewedNum');
	if(obj) SewedNum=obj.value;
    var val = parseInt(PreOperNum) + parseInt(AddNum) - parseInt(UnSewNum);
    
    if(val !== 0)
    {
        alert(t["val:error"]);
        return;
    }
    	
	if((ANOPCId=="")||(ANOPCId==" ")){
		var obj=document.getElementById('AddCount')
		if(obj) var encmeth=obj.value;
		var ret=cspRunServerMethod(encmeth,CountItemId,opaId,"",PreOperNum,AddNum,UnSewNum,SewedNum,SelfDefine,Note);
	}
	else {
		var obj=document.getElementById('UpdateCount')
		if(obj) var encmeth=obj.value;
		//alert("CountItemId="+CountItemId+" ANOPCId="+ANOPCId+" PreOperNum="+PreOperNum+" AddNum="+AddNum+" UnSewNum="+UnSewNum+" SewedNum="+SewedNum)
		var ret=cspRunServerMethod(encmeth,CountItemId,ANOPCId,"",PreOperNum,AddNum,UnSewNum,SewedNum,SelfDefine,Note);
	}
	if (ret!='0'){
		alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
	} catch(e) {};
}
//删除
function BDelete_click()
{
	if(preRowInd<1)return;
	var obj=document.getElementById('ANOPCId')
	if(obj) var ANOPCId=obj.value;
	if(ANOPCId=="")
	{
		alert(t['03']) 
		return;
		}
	var obj=document.getElementById('DeleteCount')
	if(obj) var encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ANOPCId);
	if (ret!='0')
		{
			alert(t['baulk']);
			return;
		}	
	else {
			alert(t['succeed']);
	   	 	window.location.reload();
		} 
}
function UpdateKeyDown(){
	if (window.event.keyCode!=13) return;
	var eSrc=window.event.srcElement;
	var cellname=eSrc.name;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var objSelrow=document.getElementById("selrow");
    objSelrow.value=selectrow;
	if (!selectrow) return;

	var opaId="",ANOPCId="",CountItemId="",PreOperNum="",AddNum="",UnSewNum="",SewedNum="";
	var obj=document.getElementById('opaId')
	if(obj) var opaId=obj.value;
	var selrow=document.getElementById("selrow").value;
	if (selrow=="") return;
	CountItemId=document.getElementById('OPCountIdz'+selrow).value;
	PreOperNum=document.getElementById('tPreOperNumz'+selrow).value;
	AddNum=document.getElementById('tAddNumz'+selrow).value;
	if ((cellname.indexOf("tPreOperNum")>-1)||((cellname.indexOf("tAddNum")>-1))){
			if (PreOperNum!=""){
				if (AddNum=="") AddNum=0;
				UnSewNum= eval(PreOperNum) + eval(AddNum);
				SewedNum=UnSewNum;
			}
			else {return;}
	}
	else {
		UnSewNum=document.getElementById('tUnSewNumz'+selrow).value;
		SewedNum=document.getElementById('tSewedNumz'+selrow).value;
	}
	
	var srcId = eSrc.id;
	if(srcId.indexOf("tSewedNum") != -1 || srcId.indexOf("tUnSewNum") != -1)
	{
	   var val = parseInt(document.getElementById(srcId).value);
	   if(isNaN(val))
	   {
	       alert(t["val:invaild"]);
	       return;
       }
       
       var preOperNum = parseInt(document.getElementById('tPreOperNumz'+selrow).value);
       var addNum = parseInt(document.getElementById('tAddNumz'+selrow).value);
       
       if(preOperNum + addNum != val)
       {
            alert(t["val:error"]);
            return;
       }
       
       UnSewNum = SewedNum = val;
    }
    
	ANOPCId=document.getElementById('tANOPCIdz'+selrow).value;
	//alert("CountItemId="+CountItemId+" PreOperNum="+PreOperNum+" AddNum="+AddNum+" UnSewNum="+UnSewNum+" SewedNum="+SewedNum+" ANOPCId="+ANOPCId);
	if((ANOPCId=="")||(ANOPCId==" ")){
		return;
	}
	else {
		var obj=document.getElementById('UpdateCount')
		if(obj) var encmeth=obj.value;
		var ret=cspRunServerMethod(encmeth,CountItemId,ANOPCId,PreOperNum,AddNum,UnSewNum,SewedNum);
	}
	if (ret!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    //alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
}
function GetOPCountType(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("CountType")
	obj.value=loc[1];
	var obj=document.getElementById("CountTypeId")
	obj.value=loc[2];	
	var obj=document.getElementById('opaId')
	if(obj) var opaId=obj.value;
	var obj=document.getElementById('InsertDefCountItem')
	if((obj)&&(loc[2]!="")&&(opaId!="")) {
		var ret=cspRunServerMethod(obj.value,loc[2],opaId);
		if(ret!=0) 
		{
			alert(ret);
			return;
			}
		try {
	    	window.location.reload();
		} catch(e) {};

	}
}
function GetCountItem(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("CountItem")
	obj.value=loc[1];
	var obj=document.getElementById("CountItemId")
	obj.value=loc[0];
}

function GetFilePath()
{   var GetPath=document.getElementById("GetPath").value;
    var path=cspRunServerMethod(GetPath);
    return path
}
//old only print QiCaiQingDianDan
function btnPrintClick()
{
    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter;
    var path,fileName;
    path = GetFilePath();
    fileName=path + "DHCANCOPCount.xls";
    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName);
    xlsSheet = xlsBook.ActiveSheet;
    xlsTop=1;xlsLeft=1;
    var InstrNur="",cirNur="";
    var opaId=document.getElementById("opaId").value;
	if (opaId==""){alert(t['alert:selop']);return;}
 	var PatInfo=document.getElementById("GetPatInfo");
	if (PatInfo){
    	var PatInfoStr=cspRunServerMethod(PatInfo.value,opaId);
		var patInfo=PatInfoStr.split("^");
		InstrNur=patInfo[11];
		cirNur=patInfo[12];
	}

    var objtbl=document.getElementById('tDHCANOPCount');
	var TotalRow=27; 			//Set 27 Rows snaking 
	//var ClearStr="A3:J28";	//Set Clear Area
	var row=2;					//Set Print Data from  2nd Row
	for(var i=1;i<objtbl.rows.length;i++)
	{
		var OPCountDesc=document.getElementById('OPCountDescz'+i).innerText;
		var PreOperNum=document.getElementById('tPreOperNumz'+i).value;
		var AddNum=document.getElementById('tAddNumz'+i).value;
		var UnSewNum=document.getElementById('tUnSewNumz'+i).value;
		var SewedNum=document.getElementById('tSewedNumz'+i).value;
		var isEven;
		var curPage=parseInt(i/TotalRow);
		if(curPage%2 == 0)   
   		{   
      		isEven=1;  //even
   		}else{   
      		isEven=0;  //odd
   		}   	
		if(isEven==1){
			xlsSheet.cells(row+i-curPage*TotalRow,1)=OPCountDesc;
			xlsSheet.cells(row+i-curPage*TotalRow,2)=PreOperNum;
			xlsSheet.cells(row+i-curPage*TotalRow,3)=AddNum;
			xlsSheet.cells(row+i-curPage*TotalRow,4)=UnSewNum;
			xlsSheet.cells(row+i-curPage*TotalRow,5)=SewedNum;
		}
		else{
			xlsSheet.cells(row+i-curPage*TotalRow+1,6)=OPCountDesc;
			xlsSheet.cells(row+i-curPage*TotalRow+1,7)=PreOperNum;
			xlsSheet.cells(row+i-curPage*TotalRow+1,8)=AddNum;
			xlsSheet.cells(row+i-curPage*TotalRow+1,9)=UnSewNum;
			xlsSheet.cells(row+i-curPage*TotalRow+1,10)=SewedNum;
		}
	}
	xlsSheet.cells(TotalRow+row+1,6)=cirNur;
	xlsSheet.cells(TotalRow+row+2,6)=InstrNur;
    xlsSheet.PrintOut
    xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
}
//for shenyang print HuLiDan and QiCaiQingDianDan
function btnPrintClick1()
{
    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter;
    var path,fileName;
    path = GetFilePath();
    fileName=path + "DHCANCOPCountSY.xls";
    //fileName="C:\\DHCANCOPCount.xls";
    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName);
    xlsSheet = xlsBook.ActiveSheet;
    xlsTop=1;xlsLeft=1;
    var patOpDate="",patLoc="",patMedCareNo="",patName="",patSex="",patAge="",patPreDiag="",patOpName="",patOpDoc="",InstrNur="",cirNur="";
    var opaId=document.getElementById("opaId").value;
	if (opaId==""){alert(t['alert:selop']);return;}
 	var PatInfo=document.getElementById("GetPatInfo");
	if (PatInfo){
    	var PatInfoStr=cspRunServerMethod(PatInfo.value,opaId);
		var patInfo=PatInfoStr.split("^");
		patLoc=patInfo[0];
		patMedCareNo=patInfo[4];
		patName=patInfo[1];
		patSex=patInfo[2];
		patAge=patInfo[3];
		patPreDiag=patInfo[13];
		patOpDate=patInfo[7];
		patOpName=patInfo[8];
		patOpDoc=patInfo[14];
		InstrNur=patInfo[11];
		cirNur=patInfo[12];
	}
	//patitent base information
	var row=3;
	xlsSheet.cells(row,8)=patOpDate;
	row=row+1;
	xlsSheet.cells(row,2)=patLoc;
	xlsSheet.cells(row,4)=patMedCareNo;
	xlsSheet.cells(row,6)=patName;
	xlsSheet.cells(row,8)=patSex;
	xlsSheet.cells(row,10)=patAge;
	xlsSheet.cells(row,12)=patPreDiag;
	row=row+1;
	xlsSheet.cells(row,3)=patOpName;
	xlsSheet.cells(row,9)=patOpDoc;

	var GetCareRecord=document.getElementById("GetCareRecord").value;
    var res=cspRunServerMethod(GetCareRecord,opaId);
	var CareRecord=res.split("@");
	var SQCareRecord=CareRecord[0];
	var SZCareRecord=CareRecord[1];
	var SHCareRecord=CareRecord[2];
	//SQ
	var tmpSQCareRecord=SQCareRecord.split("^");
	row=row+1;
	//SQSkin
	var SQSkin=tmpSQCareRecord[5];
	xlsSheet.cells(row,4)=SQSkin;
	//SZ
	var tmpSZCareRecord=SZCareRecord.split("^");
	row=row+1;
	//TiWei
	var OperPosition=tmpSZCareRecord[0];
	xlsSheet.cells(row,3)=OperPosition;
	//SZShuye
	var SZIntravenInfusion=tmpSZCareRecord[9];
	xlsSheet.cells(row,7)=SZIntravenInfusion;
	//DaoNiao
	var CareUrineCatheter=tmpSZCareRecord[10];
	xlsSheet.cells(row,9)=CareUrineCatheter;
	
	row=row+1;
	var CareFreezingSlice=tmpSZCareRecord[7];
	xlsSheet.cells(row,4)=TransCodeToDesc(CareFreezingSlice);
	var CarePathologSection=tmpSZCareRecord[8];
	xlsSheet.cells(row,7)=TransCodeToDesc(CarePathologSection);
	//YinLiu
	var CareDrainageCatheter=tmpSZCareRecord[12]
	xlsSheet.cells(row,10)=CareDrainageCatheter;
	//SH
	var tmpSHCareRecord=SHCareRecord.split("^");
	row=row+1;
	//LiShiLeiXing
	var SHSkin=tmpSHCareRecord[3];
	xlsSheet.cells(row,4)=SHSkin;
	var ANSType=tmpSHCareRecord[1];
	if (ANSType=="W") {
		xlsSheet.cells(row,9)=t['val:ward'];
	}
	if (ANSType=="I") {
		xlsSheet.cells(row,9)="ICU";
	}
		if (ANSType=="PI") {
		xlsSheet.cells(row,9)="PACU";
	}
	if (ANSType=="") {
		xlsSheet.cells(row,9)="";
	}	
    var objtbl=document.getElementById('tDHCANOPCount');
	var TotalRow=19; 			//Set 18 Rows snaking 
	//var ClearStr="A3:J28";	//Set Clear Area
	var row=10;					//Set Print Data from  10th Row
	for(var i=1;i<objtbl.rows.length;i++)
	{
		var OPCountDesc=document.getElementById('OPCountDescz'+i).innerText;
		var PreOperNum=document.getElementById('tPreOperNumz'+i).value;
		var AddNum=document.getElementById('tAddNumz'+i).value;
		var UnSewNum=document.getElementById('tUnSewNumz'+i).value;
		var SewedNum=document.getElementById('tSewedNumz'+i).value;
		var isEven;
		var curPage=parseInt(i/TotalRow);
		alert(curPage)
		if(curPage%2 == 0)   
   		{   
      		isEven=1;  //even
   		}else{   
      		isEven=0;  //odd
   		}   	
		if(isEven==1){
			xlsSheet.cells(row+i-curPage*TotalRow,1)=OPCountDesc;
			xlsSheet.cells(row+i-curPage*TotalRow,3)=PreOperNum;
			xlsSheet.cells(row+i-curPage*TotalRow,4)=AddNum;
			xlsSheet.cells(row+i-curPage*TotalRow,5)=UnSewNum;
			xlsSheet.cells(row+i-curPage*TotalRow,6)=SewedNum;
		}
		else{
			xlsSheet.cells(row+i-curPage*TotalRow+1,7)=OPCountDesc;
			xlsSheet.cells(row+i-curPage*TotalRow+1,9)=PreOperNum;
			xlsSheet.cells(row+i-curPage*TotalRow+1,10)=AddNum;
			xlsSheet.cells(row+i-curPage*TotalRow+1,11)=UnSewNum;
			xlsSheet.cells(row+i-curPage*TotalRow+1,12)=SewedNum;
		}
	}
	xlsSheet.cells(TotalRow+row+1,6)=cirNur;
	xlsSheet.cells(TotalRow+row+2,6)=InstrNur;
    xlsSheet.PrintOut
    xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
}
///Code:Y(有)/N(无) 
function TransCodeToDesc(Code)
{
	var Desc="";
	if (Code=="Y") Desc=t['val:yes'];
	else {
		if (Code=="N") Desc=t['val:no'];
	}
	return Desc;
}
document.body.onload=BodyLoadHandler;
