var iSeldRow=0
var InsuRow=0
var GROUPID=session['LOGON.GROUPID']
var idTmr=""
function BodyLoadHandler() {
	
	var obj=document.getElementById("Contrast");
	if (obj){ obj.onclick=Updat_click;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}	
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=List_click;}	
	var obj=document.getElementById("Query");
	if(obj){obj.onclick=Query_onclick}
	var obj=document.getElementById("ExportXLS");
	if(obj){obj.onclick=ExportXLS_onclick;}
	
	var obj=document.getElementById("tINSUTarContrast1");
	if (obj){obj.onkeydown=FrameEnterkeyCode;}
	
	var obj=document.getElementById("sKeyWord");
	if (obj) {obj.onkeydown=KeyDown; }

	ini();
	
	}
	
function KeyDown(){
	if (window.event.keyCode==13){
		Query_onclick();
	}
 }
	
function Query_onclick()        //20090422 增加按日期查询功能控制
{   var obj=document.getElementById("Class");
	if (obj.value=="4")
	{
		var obj=document.getElementById("sKeyWord");
		//alert(obj.value)
		if (obj.value!="")
			{
			var flag=validateCNDate(obj.value) //DHCINSUCommon.js
			if(flag){Query_click()}
			}
		else {alert("请输入日期")}
	}
	else {Query_click();}
}

function ini(){
	var obj=document.getElementById("Type");
	if (obj){
		
	  obj.size=1; 
	  obj.multiple=false;
	  var Flag=FillTypeList(obj)
	  if (Flag){
		var n=obj.length
		var Typeobj=document.getElementById("TypeSave");
		if(Typeobj.value==""){
			obj.options[0].selected=true
		}
		else{
			for (var i =0;i<n;i++){
				if(obj.options[i].value==Typeobj.value){
				obj.options[i].selected=true
				}
			}
		}
	  }
	}
	var obj=document.getElementById("Class");
	if (obj){	
	  obj.size=1; 
	  obj.multiple=false;	 
	  obj.options[0]=new Option(t['msClass1'],"1");
	  obj.options[1]=new Option(t['msClass2'],"2");
	  obj.options[2]=new Option(t['msClass3'],"3");
	  //obj.options[3]=new Option(t['msClass4'],"4");
	  //obj.options[4]=new Option("查询所有限制药品","5");
		}
	var obj=document.getElementById("Class");
	if (obj){
      var n=obj.length
      for (var i =0;i<n;i++){
		  var Typeobj=document.getElementById("ClassSave");
		  if(obj.options[i].value==Typeobj.value){
		  obj.options[i].selected=true
		  }
	      }
	}
	
	var obj=document.getElementById("ConType");
	if (obj){	
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option(t['msConType1'],"A");
	  obj.options[1]=new Option(t['msConType2'],"Y");
	  obj.options[2]=new Option(t['msConType3'],"N");
		}
		
	var obj=document.getElementById("ConType");
	if (obj){
      var n=obj.length
      for (var i =0;i<n;i++){
		  var Typeobj=document.getElementById("ConTypeSave");
		  if(obj.options[i].value==Typeobj.value){
		  obj.options[i].selected=true
		  }
	  }
	}
}
		
function SetTarCate(value){	
	var TarCate=value
	var TempData=TarCate.split("^")
	var obj=document.getElementById("TarCate");
	if (obj){obj.value=TempData[0]}
	var obj=document.getElementById("TarCateDesc");
	if (obj){obj.value=TempData[2]}	
	}

function List_click(){
	var InsuType=""
	obj=document.getElementById('Type');
	if (obj) {InsuType=obj.value};
	if ((InsuType=="")||(ssTarId=="")){return false}	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=INSUTarContrastListCom&TarId='+ssTarId+'&Type='+InsuType;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=680,height=520,left=0,top=0')
    //location.href=str
}


	
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tINSUTarContrast1');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

    
	if (!selectrow) return;
	if (iSeldRow==selectrow){
		iSeldRow=0
		ssTarId="";
		ssHisCode="";
		ssHisDesc="";
		ssConId="";
		ssInsuId="";
		ssInsuCode="";
		ssInsuDesc="";
		return;
		}
	iSeldRow=selectrow;
	var SelRowObj
	var obj
	//ssTarId,ssHisCode,ssHisDesc,ssConId,ssInsuId,ssInsuCode,ssInsuDesc
	SelRowObj=document.getElementById('TarIdz'+selectrow);
	if (SelRowObj){ssTarId=SelRowObj.value}
	else{ssTarId=""}	
	SelRowObj=document.getElementById('HisCodez'+selectrow);
	if (SelRowObj){ssHisCode=SelRowObj.innerText}
	else{ssHisCode=""}
	
	SelRowObj=document.getElementById('HisDescz'+selectrow);
	if (SelRowObj){ssHisDesc=SelRowObj.innerText}
	else{ssHisDesc=""}
	
	SelRowObj=document.getElementById('ConIdz'+selectrow);	
	if (SelRowObj){ssConId=SelRowObj.value}
	else{ssConId=""}
	
	SelRowObj=document.getElementById('TInsuIdz'+selectrow);	
	if (SelRowObj){ssInsuId=SelRowObj.value}
	else{ssInsuId=""}
	
	SelRowObj=document.getElementById('InsuCodez'+selectrow);	
	if (SelRowObj){ssInsuCode=SelRowObj.innerText}
	else{ssInsuCode=""}
	ssInsuCode=cTrim(ssInsuCode) //Lou 2010-09-03 LINK改为TextBox后有空格??  //DHCINSUCommon.js
	
	SelRowObj=document.getElementById('InsuDescz'+selectrow);		
	if (SelRowObj){ssInsuDesc=SelRowObj.innerText}
	else{ssInsuDesc=""}
	
	InsuRow=selectrow
	//--------------Lou 2010-08-26 该段程序依实际情况修改-------------------------------------
	//如果做过医保对照,将对照的医保代码带入下一组件,未做对照的将计费项名称带入下一组件
	var obj=parent.frames["INSUTarContrast2"].document.getElementById("UpdateStr");
	obj.value=ssConId+"^"+ssTarId+"^"+ssHisCode+"^"+ssHisDesc+"^"+ssInsuId+"^"+ssInsuCode+"^"+ssInsuDesc
	if (ssInsuCode!=""){
		var obj=parent.frames["INSUTarContrast2"].document.getElementById("Desc");
		obj.value=""
		var obj=parent.frames["INSUTarContrast2"].document.getElementById("Alias");
		obj.value=""
		var obj=parent.frames["INSUTarContrast2"].document.getElementById("Code");
		obj.value=ssInsuCode;
		parent.frames["INSUTarContrast2"].Query_onclick();
		//parent.frames["INSUTarContrast2"].GetContrastInsuID();
		}
	else{
		var obj=parent.frames["INSUTarContrast2"].document.getElementById("Alias");
		obj.value=""
		var obj=parent.frames["INSUTarContrast2"].document.getElementById("Code");
		obj.value=""
		var tmpHisDesc=GetDescByssHisDesc(ssHisDesc) //名称去掉括号等,按主关键字查找
		var obj=parent.frames["INSUTarContrast2"].document.getElementById("Desc");
		obj.value=tmpHisDesc;
		parent.frames["INSUTarContrast2"].Query_onclick();
		}	
	//----------------------------------------------------------------------------------------

}	

	function FillTypeList(obj){
	//var OutStr=-1
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","","TariType");
	if ((VerStr=="0")||(VerStr=="")){
		alert("请在医保字典表中维护医保的目录类别")
		return false;
	}
	var i
	var VerArr1=VerStr.split("!");
	var ArrTxt= new Array(VerArr1.length-2);     //定义数组长度
	var ArrValue = new Array(VerArr1.length-2);  //定义数组长度
	for(i=1;i<VerArr1.length;i++){
		var VerCol=VerArr1[i].split("^");
		var VerArr3=VerCol[5].split("#");
		for(j=1;j<=VerArr3.length;j++)
		{
			//根据医保码列维护的安全组列表吗?判断本目录哪些人可以看见
			if(GROUPID==VerArr3[j-1]||(VerCol[5]=="ALL")||(VerCol[5]==""))
			{
				ArrTxt[i-1]=VerCol[3];
				ArrValue[i-1]=VerCol[2];
			}
		}
		//ArrTxt[i-1]=VerCol[3];
		//ArrValue[i-1]=VerCol[2];
		}
	ClearAllList(obj);
	var Flag=AddItemToList(obj,ArrTxt,ArrValue);
	return Flag;
	}
function ClearAllList(obj) {
	if (obj.options.length>0) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}	
function AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {
		if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {
				obj.options[lstlen] = new Option(arytxt[i],aryval[i]); 
				
				/*
				var AvlQty=aryval[i].split("&")
				//alert(AvlQty[4])
				if ( AvlQty[4]== 1 ) {
					obj.options[lstlen].style.color="green";
				}
				if( AvlQty[4]<1 ){
					obj.options[lstlen].style.color="red";
				}
				*/
				lstlen++;
			}
			return true;
		}
	}
}

//Lou 2010-08-27 HIS名称去掉括号或其他信息,得到主关键信息,依实际情况修改
function GetDescByssHisDesc(ssHisDesc){
		var tmp,tmpHisDesc
		tmpHisDesc=ssHisDesc
		tmp=tmpHisDesc.split("(");
		tmpHisDesc=tmp[0];
		tmp=tmpHisDesc.split("?");
		tmpHisDesc=tmp[0];
		tmp=tmpHisDesc.split("");
		tmpHisDesc=tmp[0];
		tmp=tmpHisDesc.split("[");
		tmpHisDesc=tmp[0];
		tmp=tmpHisDesc.split("");
		tmpHisDesc=tmp[0];
		return tmpHisDesc;
	}

function DHCC_SetColumnData(ColName,Row,Val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//var rowobj=tk_getRow(CellObj);
	//var objtbl=tk_getTBody(rowobj)
	if (CellObj){
	  //alert(CellObj.id+"^"+CellObj.tagName);
	  //CellObj.innerText=Val;
	  if (CellObj.tagName=='LABEL'){
	  	CellObj.innerText=Val;
	  }else{
			if (CellObj.type=="checkbox"){
				if (Val==1) {CellObj.checked=true;}else{CellObj.checked=false}
			}else{
				CellObj.value=Val;
			}
		}
	}
}
function FrameEnterkeyCode()
{
	var e=window.event;
	switch (e.keyCode){
		//上下移动光标键
	case 38:
		var objtbl=window.document.getElementById('tINSUTarContrast1');
		if (iSeldRow==1) {break;}
		var objrow=objtbl.rows[iSeldRow-1];
		objrow.click();
		break;
	case 40:
		var objtbl=window.document.getElementById('tINSUTarContrast1');
		var rows=objtbl.rows.length-1;
		if (iSeldRow==rows) {break;}
		var objrow=objtbl.rows[iSeldRow+1];
		objrow.click();
		break;
	}
}

//导出查询明细
//Zhan 2012-03-15	
function ExportXLS_onclick()
{
	try
	{
		var Repid=0;		//节点
		var PrtRowCnt=0;	//打印数据行数
		Repid=document.getElementById('Repid').value;
		PrtRowCnt=document.getElementById('PrtRowCnt').value;
		alert(Repid+"^"+PrtRowCnt)
		if((Repid==0)||(PrtRowCnt==0)){alert("没有数据,请重新查询!");return;}
		var xlspath=tkMakeServerCall("web.INSUBase","getpath")
		var xlsfilename=xlspath+"INSUCONExport.xls"		//打印模版
		var xlApp,xlsheet,xlBook
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(xlsfilename);
		xlsheet = xlBook.ActiveSheet;
		var tmpstr;
		var xlsrow=1;
		var xlsCurcol=0;
		var rowstot=eval(PrtRowCnt)+eval(xlsrow)
		var temp="A2:R"+rowstot
		xlApp.Range(temp).Select;
		xlApp.Selection.Borders.LineStyle = 1;
		//xlsheet.Range(temp).RowHeight = 30;		//影响执行效率
		for (var i=0;i<PrtRowCnt;i++)
		{
			xlsrow+=1
			tmpstr=ListData(Repid,i);
			var tmparr=tmpstr.split("^");
			//xlsheet.Range(xlsheet.Cells(xlsrow,1),xlsheet.Cells(xlsrow,18))= tmparr;
			//xlsheet.Range("A"+xlsrow+":R"+xlsrow)= tmparr ;
			for(var j=0;j<tmparr.length;j++)
			{
				xlsheet.Cells(xlsrow,j+1)=tmparr[j];
			}
		}
		xlApp.Visible=false;
		var Eptename = xlApp.Application.GetSaveAsFilename("ExportConfile.xls", "Excel Spreadsheets (*.xls), *.xls");
		//xlApp.UserControl = true; 
		xlsheet.SaveAs(Eptename);
		//xlsheet.PrintPreview();	//打印预览
		//xlApp.document.execcommand('saveas', true, "test");	//显示EXCEL
		xlsheet = null;
		xlBook.Close(savechanges=false);
		xlBook = null;
		xlApp.Quit();
		xlApp=null;
		xlsheet=null   
		window.setInterval("Cleanup();",1); 
		
		//清理垃圾
		tkMakeServerCall("web.INSUTarContrastCom","ClearTmpGlobal",repid);
	
	} catch(e) {
		alert(e.message);
	};

}

//取打印数据
function ListData(repid,index)
{  
	var str=tkMakeServerCall("web.INSUTarContrastCom","GetPrtDateByID",repid,index);
	return str
}
//关闭EXCEL
function Cleanup() 
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}

/*


//增加目录同步按钮
function UpdateInsuTarCon()
{
	alert("开始同步HIS目录")
	var TypeobjTmp=document.getElementById("Type");
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSUWHB"); //管道局医保
	var TypeTmp=TypeobjTmp.value
	var OutStr=DHCINSUBLL.UpdateInsuTarCon(TypeTmp) 
}
*/
document.body.onload = BodyLoadHandler;