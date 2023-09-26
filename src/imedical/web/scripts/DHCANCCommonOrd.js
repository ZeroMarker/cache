document.write("<OBJECT id=dlgHelper CLASSID='clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b' width='0px' height='0px'>");
document.write("</object>");

var selectRow=-1;
var ID=0,preRowInd=0;
var itmId="",arcosId="";
function BodyLoadHandler() 
{
	var obj=document.getElementById("needArcimDescList");
	if (obj) obj.ondblclick = ArcimDescList_Dublclick;
	var onj=document.getElementById("needArcimDesc");
	if (obj) obj.onkeydown=ArcimDescKeyDown;
	var obj=document.getElementById('Add');
	if (obj) obj.onclick = Add_Click;
	var obj=document.getElementById('Delete');
	if (obj) obj.onclick = Delete_Click;
	var obj=document.getElementById('Update');
	if (obj) obj.onclick = Update_Click;
	var obj=document.getElementById('DelAppFlag');
	if (obj) obj.onclick = DelAppFlag_Click;	
	var obj=document.getElementById('ItemCatName');
	if (obj) obj.onblur = ItemCatBlue;
	//ypz begin
	obj=document.getElementById('selectColor'); 
	if (obj) obj.onclick =Color_click; 
	obj=document.getElementById('ColorDesc'); 
    if (obj) 
    {
	    obj.onkeypress=HexFilter;
	    obj.onblur=FormatColor;
    }
    var ancoDataType = document.getElementById("ancoDataType");
    var obj=document.getElementById("ANCOTemplateSubAncoDr");
    if (obj){obj.onkeydown=LookANCOTemplateSubAncoDr;}
    var obj=document.getElementById("ANCOTemplateSubAncoList");
    if (obj) {obj.ondblclick=AnaMethodList_Dublclick;}
    //ypz end	
}
function Update_Click()
{
	if(!CheckData())
    {
	    return ;
	}

	if (preRowInd<1) return;	
	var ANCOAnApply="",ANCOIcuApply="";
	 var typeobj=document.getElementById('ANCOCode');
	 if (typeobj) var ANCOCode=typeobj.value;
	 var typeobj=document.getElementById('ANCODesc');
	 if (typeobj) var ANCODesc=typeobj.value;
	 	 //汇总格式+dyl
	 var typeobj=document.getElementById('ANCOSumFormat');
	 if (typeobj) var ANCOSumFormat=typeobj.value;
	 var typeobj=document.getElementById('ANCOSumFormatField');
	 if (typeobj) var ANCOSumFormatField=typeobj.value;

	 var typeobj=document.getElementById('CatID');
	 if (typeobj) var ANCOType=typeobj.value;
	 //alert(typeobj.value);
	 switch(typeobj.value)
	 {
		 case "D":
		 	 if (typeobj) var ANCOType="D";
		 	 break;
		 case "V":
		 	 if (typeobj) var ANCOType="V";
		 	 break;
		 case "E":
		 	 if (typeobj) var ANCOType="E";
		 	 break;
		 case "T":
		 	 if (typeobj) var ANCOType="T";
		 	 break;
		 case  "L":
		 	 if (typeobj) var ANCOType="L";
		 	 break;		 	 		 	 
		 default:
		 	 if (typeobj) var ANCOType="D";
		 	 break;
	 }
	 //var typeobj=document.getElementById('Name');
	 //if (typeobj) var ANCOArcim=typeobj.value;
	 var ANCOArcim=GetListData("needArcimDescList");	 
	 //var typeobj=document.getElementById('ANCEViewCatId');
	 //if (typeobj) var ANCEViewCatId=typeobj.value;
	 //wxl
	 var typeobj=document.getElementById('UomRowId');
	 if (typeobj) var ANCOUomDrId=typeobj.value;
	 var typeobj=document.getElementById('IconRowId');
	 if (typeobj) var ANCOIconDrId=typeobj.value;
	 var typeobj=document.getElementById('ColorDesc');
	 if (typeobj) var ANCOColor=typeobj.value;
	 var typeobj=document.getElementById('Options');
	 if (typeobj) var ANCOOptions=typeobj.value;
	 
	 var typeobj=document.getElementById('itmId');//yangqin20121031
	 if (typeobj) var itmId=typeobj.value;
	 
	 var typeobj=document.getElementById('IcuApply');
	 if (typeobj)
	 {
		 if(typeobj.value=="Y") ANCOIcuApply="Y";
	 	 else ANCOAnApply="Y";
	 }
	 var ancoMultiValueDesc=""
	 var objAncoMultiValueDesc=document.getElementById('ancoMultiValueDesc');
	 if (objAncoMultiValueDesc) ancoMultiValueDesc=objAncoMultiValueDesc.value;
	 var obj=document.getElementById('ANCEViewCat');
	 var ancViewCatIdStr=selitem(obj,'|');
	 var ancoSortNo="";
	 var objAncoSortNo=document.getElementById('ancoSortNo');
	 if (objAncoSortNo) ancoSortNo=objAncoSortNo.value;
	 //alert(ancoSortNo);return;
	 var objAncoDataType = document.getElementById("ancoDataType");
	 var ancoDataType="";
	if(objAncoDataType) ancoDataType = objAncoDataType.value;	
	
	//mfc 121227 数据类型和选项对应
    /*if (ANCOOptions.indexOf(";")==0){		 
		 if ((ancoDataType!="M")&&(ancoDataType!="C")){			 
		   alert("数据类型应为单选或者多选");
		   retrun;
		 }
	}*/
	
	//whl 20120420
	
	 var ANCOMaxobj=document.getElementById('ANCOMax');
	 if (ANCOMaxobj) var ANCOMax=ANCOMaxobj.value;
	 var ANCOMinobj=document.getElementById('ANCOMin');
	 if (ANCOMinobj) var ANCOMin=ANCOMinobj.value;
	 var ANCOImpossibleMaxobj=document.getElementById('ANCOImpossibleMax');
	 if (ANCOImpossibleMaxobj) var ANCOImpossibleMax=ANCOImpossibleMaxobj.value;
	 var ANCOImpossibleMinobj=document.getElementById('ANCOImpossibleMin');
	 if (ANCOImpossibleMinobj) var ANCOImpossibleMin=ANCOImpossibleMinobj.value;
	 var ANCOMainAncoDrobj=document.getElementById('ANCOMainAncoDrid');
	 if (ANCOMainAncoDrobj) var ANCOMainAncoDr=ANCOMainAncoDrobj.value;
	 var ANCODataFieldobj=document.getElementById('ANCODataField');
	 if (ANCODataFieldobj) var ANCODataField=ANCODataFieldobj.value;
	 //alert(ANCODataField)
	 var ANCODataFormatobj=document.getElementById('ANCODataFormat');
     if (ANCODataFormatobj) var ANCODataFormat=ANCODataFormatobj.value;	 
     var ANCOFormatFieldobj=document.getElementById('ANCOFormatField');
     if (ANCOFormatFieldobj) var ANCOFormatField=ANCOFormatFieldobj.value;
	 //mfc 121227 数据格式和格式字段对应
     if (ANCODataFormat.indexOf("{")==0){
		 var DateCount=(ANCODataFormat.split("{")).length;
		 var FieldCount=(ANCOFormatField.split(";")).length;
		 if (DateCount!=(FieldCount+1)){
		   alert("数据格式与格式字段个数不否");
		   retrun;
		 }
	 }
	 var ANCOTemplateAncoDrIDobj=document.getElementById('ANCOTemplateAncoDrID');
	 if (ANCOTemplateAncoDrIDobj) var ANCOTemplateAncoDrID=ANCOTemplateAncoDrIDobj.value;
	 //ADD MFC 20121203
	 //var ANCOTemplateSubAncoDrIDobj=document.getElementById('ANCOTemplateSubAncoDrID');
	 //if (ANCOTemplateSubAncoDrIDobj) var ANCOTemplateSubAncoDrID=ANCOTemplateSubAncoDrIDobj.value;    
    var objList=document.getElementById('ANCOTemplateSubAncoList');
	var retString=""
	if(objList){
		for (var i=0;i<objList.options.length;i++)
	   	{
		   if (objList.options[i].value!="")
		   {
			   if(retString==""){
				   retString=objList.options[i].value
				   //alert(retString)
			   }
			   else{
				   retString=retString+"|"+objList.options[i].value
			   }
		   }
		}
	}	
	var ANCOTemplateSubAncoDrID=retString;
	//
	 var p1=ANCOCode+"^"+ANCODesc+"^"+ANCOType+"^"+ANCOArcim+"^"+ancViewCatIdStr+"^"+ANCOUomDrId+"^"+ANCOIconDrId+"^"+ANCOColor+"^"+ANCOAnApply+"^"+ANCOIcuApply
	 p1=p1+"^"+ANCOOptions+"^"+itmId+"^"+ancoMultiValueDesc+"^"+ancoSortNo+"^"+arcosId + "^" + ancoDataType+ "^"+ANCOMax+"^"+ANCOMin+"^"+ANCOImpossibleMax+ "^"+ANCOImpossibleMin
	 p1=p1+ "^"+ANCOMainAncoDr+ "^"+ANCODataField+ "^"+ANCODataFormat+"^"+ANCOFormatField+"^"+ANCOTemplateAncoDrID+"^"+ANCOTemplateSubAncoDrID+"^"+ANCOSumFormat+"^"+ANCOSumFormatField;
    //alert(p1);
	 var UpdateObj=document.getElementById('UpdateCommonOrd');
	 // alert(UpdateObj)
	 if (UpdateObj) {var encmeth=UpdateObj.value } else {var encmeth=''};
	 
	 var Ret=cspRunServerMethod(encmeth,'addok','',ID,p1);
	 //alert(Ret)
	 var findobj=document.getElementById('Query');
		if (findobj) findobj.click();
}
function Add_Click()
{    if(!CheckData())
    {
	    return ;
	}
	 var ANCOAnApply="",ANCOIcuApply="";
	 var typeobj=document.getElementById('ANCOCode');
	 if (typeobj) var ANCOCode=typeobj.value;
	 var typeobj=document.getElementById('ANCODesc');
	 if (typeobj) var ANCODesc=typeobj.value;
	 	 //汇总格式+dyl
	 var typeobj=document.getElementById('ANCOSumFormat');
	 if (typeobj) var ANCOSumFormat=typeobj.value;
	 var typeobj=document.getElementById('ANCOSumFormatField');
	 if (typeobj) var ANCOSumFormatField=typeobj.value;

	 var typeobj=document.getElementById('CatID');
	 if (typeobj) var ANCOType=typeobj.value;
	 switch(typeobj.value)
	 {
		 case "D":
		 	 if (typeobj) var ANCOType="D";
		 	 break;
		 case "V":
		 	 if (typeobj) var ANCOType="V";
		 	 break;
		 case "E":
		 	 if (typeobj) var ANCOType="E";
		 	 break;
		 case "T":
		 	 if (typeobj) var ANCOType="T";
		 	 break;
		 case  "L":
		 	 if (typeobj) var ANCOType="L";
		 	 break;		 	 		 	 
		 default:
		 	 if (typeobj) var ANCOType="D";
		 	 break;
	 }
	 //var typeobj=document.getElementById('Name');
	 //if (typeobj) var ANCOArcim=typeobj.value;
	 var ANCOArcim=GetListData("needArcimDescList");
	 var typeobj=document.getElementById('ANCEViewCatId');
	 var obj=document.getElementById('ANCEViewCat');
	 var ANCEViewCatId=selitem(obj,'|');
	 //alert(ANCEViewCatId);return;
     if (typeobj) typeobj.value=ANCEViewCatId;
	 //wxl
	 var typeobj=document.getElementById('UomRowId');
	 if (typeobj) var ANCOUomDrId=typeobj.value;
	 var typeobj=document.getElementById('IconRowId');
	 if (typeobj) var ANCOIconDrId=typeobj.value;
	 var typeobj=document.getElementById('ColorDesc');
	 if (typeobj) var ANCOColor=typeobj.value;
	 var typeobj=document.getElementById('Options');
	 if (typeobj) var ANCOOptions=typeobj.value;
	 
	 var typeobj=document.getElementById('itmId');//yangqin20121031
	 if (typeobj) var itmId=typeobj.value;
	 //alert(itmId)
	 var typeobj=document.getElementById('IcuApply');
	 if (typeobj)
	 {
		 if(typeobj.value=="Y") ANCOIcuApply="Y";
	 	 else ANCOAnApply="Y";
	 }
	 var ancoMultiValueDesc=""
	 var objAncoMultiValueDesc=document.getElementById('ancoMultiValueDesc');
	 if (objAncoMultiValueDesc) ancoMultiValueDesc=objAncoMultiValueDesc.value;
	 var ancoSortNo="";
	 var objAncoSortNo=document.getElementById('ancoSortNo');
	 if (objAncoSortNo) ancoSortNo=objAncoSortNo.value;
	var objAncoDataType = document.getElementById("ancoDataType");
	var ancoDataType="";
	if(objAncoDataType) ancoDataType = objAncoDataType.value;
	
	//whl 20120420
	
	 var ANCOMaxobj=document.getElementById('ANCOMax');
	 if (ANCOMaxobj) var ANCOMax=ANCOMaxobj.value;
	 var ANCOMinobj=document.getElementById('ANCOMin');
	 if (ANCOMinobj) var ANCOMin=ANCOMinobj.value;
	//alert(ANCOMin);
	 var ANCOImpossibleMaxobj=document.getElementById('ANCOImpossibleMax');
	 if (ANCOImpossibleMaxobj) var ANCOImpossibleMax=ANCOImpossibleMaxobj.value;
	 var ANCOImpossibleMinobj=document.getElementById('ANCOImpossibleMin');
	 if (ANCOImpossibleMinobj) var ANCOImpossibleMin=ANCOImpossibleMinobj.value;
	 var ANCOMainAncoDrobj=document.getElementById('ANCOMainAncoDrid');
	 if (ANCOMainAncoDrobj) var ANCOMainAncoDr=ANCOMainAncoDrobj.value;
	 var ANCODataFieldobj=document.getElementById('ANCODataField');
	 if (ANCODataFieldobj) var ANCODataField=ANCODataFieldobj.value;
	 var ANCODataFormatobj=document.getElementById('ANCODataFormat');
	 if (ANCODataFormatobj) var ANCODataFormat=ANCODataFormatobj.value;
	 var ANCOFormatFieldobj=document.getElementById('ANCOFormatField');
	 if (ANCOFormatFieldobj) var ANCOFormatField=ANCOFormatFieldobj.value;
	 //alert(ANCOFormatField)
	 var ANCOTemplateAncoDrIDobj=document.getElementById('ANCOTemplateAncoDrID');
	 if (ANCOTemplateAncoDrIDobj) var ANCOTemplateAncoDrID=ANCOTemplateAncoDrIDobj.value;
	 //ADD MFC 20121203
	 //var ANCOTemplateSubAncoDrIDobj=document.getElementById('ANCOTemplateSubAncoDrID');
	 //if (ANCOTemplateSubAncoDrIDobj) var ANCOTemplateSubAncoDrID=ANCOTemplateSubAncoDrIDobj.value;
	var objList=document.getElementById('ANCOTemplateSubAncoList');
	var retString=""
	if(objList){
		for (var i=0;i<objList.options.length;i++)
	   	{
		   if (objList.options[i].value!="")
		   {
			   if(retString==""){
				   retString=objList.options[i].value
				   alert(retString)
			   }
			   else{
				   retString=retString+"|"+objList.options[i].value
			   }
		   }
		}
	}
	var ANCOTemplateSubAncoDrID=retString
	 var p1=ANCOCode+"^"+ANCODesc+"^"+ANCOType+"^"+ANCOArcim+"^"+ANCEViewCatId+"^"+ANCOUomDrId+"^"+ANCOIconDrId+"^"+ANCOColor+"^"+ANCOAnApply+"^"+ANCOIcuApply
	 p1=p1+"^"+ANCOOptions+"^"+itmId+"^"+ancoMultiValueDesc+"^"+ancoSortNo+"^"+arcosId + "^"+ancoDataType+"^"+"N"+ "^"+"  "+"^"+ANCOMax+"^"+ANCOMin
	 p1=p1+"^"+ANCOImpossibleMax+"^"+ANCOImpossibleMin+ "^"+ANCOMainAncoDr+ "^"+ANCODataField+ "^"+ANCODataFormat+"^"+ANCOFormatField+"^"+ANCOTemplateAncoDrID+"^"+ANCOTemplateSubAncoDrID+"^"+ANCOSumFormat+"^"+ANCOSumFormatField;
	 //alert(p1);
	 var InsertObj=document.getElementById('AddCommonOrd');
	 //alert(InsertObj)
	 if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);
	
	// alert(Ret);
	}
function addok(value)
	{if (value==0) {
		 var ANCOCatobj= document.getElementById('ANCOCat');
	 	if(ANCOCatobj)
	 	{
		 	ANCOCatobj.value=""
	 	}
		var findobj=document.getElementById('Query');
		if (findobj) findobj.click();
	//	window.location.reload();
	    //alert("OK");
		}
	 else alert(value);}
function Delete_Click()
{
	if (preRowInd<1) return;
     var p1=ID;
     var DeleteAnaestAgent=document.getElementById('DeleteCommonOrd');
	 if (DeleteAnaestAgent) {var encmeth=DeleteAnaestAgent.value} else {var encmeth=''};
	 //alert(p1);
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);	
}
function DelAppFlag_Click()
{
	if (preRowInd<1) return;
	var ANCOAnApply="",ANCOIcuApply="";
	var typeobj=document.getElementById('IcuApply');
	if (typeobj)
	{
		if(typeobj.value=="Y") ANCOIcuApply="N";
	 	else ANCOAnApply="N";
	}
     var p1=ID+"^"+ANCOAnApply+"^"+ANCOIcuApply;
     var ObjDelComOrdAppFlag=document.getElementById('DelComOrdAppFlag');
	 if (ObjDelComOrdAppFlag) {var encmeth=ObjDelComOrdAppFlag.value} else {var encmeth=''};
	 //alert(p1);
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);	
}


function SetCatInfo(str)
{
   // alert("dd");
	var obj=str.split("^");
	var Obj=document.getElementById("CatID");
	Obj.value=obj[0];
	var Obj=document.getElementById("ANCOCat");
	Obj.value=obj[1];	
	}
function SetANCOTemplateAncoDr(str)
  {
	//alert(str);
	var obj=str.split("^");
	var Obj=document.getElementById("ANCOTemplateAncoDr");
	Obj.value=obj[0];
	var Obj=document.getElementById("ANCOTemplateAncoDrID");
	Obj.value=obj[2];		
  }
function SetTemplateSubAncoDr(str)
  {
	//alert(str);
	var obj=str.split("^");
	var Obj=document.getElementById("ANCOTemplateSubAncoDr");
	//Obj.value=obj[0];
	//var Obj=document.getElementById("ANCOTemplateSubAncoDrID");
	//Obj.value=obj[2];	
	Obj.value="";
    var objSelected = new Option(obj[0], obj[2]);
	var obj=document.getElementById('ANCOTemplateSubAncoList');
	if (obj) obj.options[obj.options.length]=objSelected;
	}
function SetAncoMain(str)
  {
	//alert(str);
	var obj=str.split("^");
	var Obj=document.getElementById("ANCOMainAncoDr");
	Obj.value=obj[0];
	var Obj=document.getElementById("ANCOMainAncoDrid");
	Obj.value=obj[2];	
	}
function SetTypeInfo(str)
{
   
	var obj=str.split("^");
	var Obj=document.getElementById("ItemCatName");
	Obj.value=obj[0];
	var Obj=document.getElementById("ANCODataFieldId");
	Obj.value=obj[1];
	//var S=obj[1];
	//alert(Obj.value);
	}
function SetOperInfo(str)
{
	var strValue=str.split("^");
	var nameObj=document.getElementById("Name");
	nameObj.value=strValue[1];
	var obj=document.getElementById("needArcimDesc");
	if(obj)
	{
		addListRow("needArcimDescList",strValue);
		obj.value=""
		websys_setfocus("needArcimDesc");
	}
}
function SetANCEViewCat(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("ANCEViewCat");
	Obj.value=obj[0];
	var Obj=document.getElementById("ANCEViewCatId");
	Obj.value=obj[1];	
	}
//wxl
function SetUom(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("UomDesc");
	Obj.value=obj[0];
	var Obj=document.getElementById("UomRowId");
	Obj.value=obj[1];	
	}		
	
//wxl
function SetIcon(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("IconDesc");
	Obj.value=obj[0];
	var Obj=document.getElementById("IconRowId");
	Obj.value=obj[1];	
}
			
function SetObItm(str)
{
	var list=str.split("^");
	itmId="";
	if (list.length>1)
	{
		var obj=document.getElementById("itmDesc");
		obj.value=list[0];
		var obj=document.getElementById("itmId");
		obj.value=list[1];	
	}
}
function SetArcos(str)
{
	var list=str.split("^");
	arcosId="";
	if (list.length>1)
	{
		arcosId=list[0];	
		var obj=document.getElementById("arcOrdSets");
		obj.value=list[1];
	}
}
	
			
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCANCCommonOrd');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	selectRow=rowObj.rowIndex;
	if (!selectRow) return;
	var SelRowObj=document.getElementById('tRowIDz'+selectRow);
	ID=SelRowObj.innerText;
		//2013+dyl
	SetElementByElement('ANCOSumFormatField',"V",'tANCOSumFormatFieldz'+selectRow,"I"," ","");
	SetElementByElement('ANCOSumFormat',"V",'tANCOSumFormatz'+selectRow,"I"," ","");
    var typeobj=document.getElementById('ANCOCode');
	var typeobj1=document.getElementById('ANCODesc');
	var typeobj2=document.getElementById('ANCOCat');
	var typeobj3=document.getElementById('needArcimDesc');
	var typeobj4=document.getElementById('Name');
	var typeobj5=document.getElementById('CatID');
	var typeobj6=document.getElementById('needItemCatId');
	var typeobj7=document.getElementById('ItemCatName');
	var typeobj8=document.getElementById('ANCEViewCatId');
	var typeobj9=document.getElementById('ANCEViewCat');
	//wxl
	var typeobj10=document.getElementById('UomRowId');
	var typeobj11=document.getElementById('UomDesc');
	var typeobj12=document.getElementById('IconRowId');
	var typeobj13=document.getElementById('IconDesc');
	var typeobj14=document.getElementById('ColorDesc');
	var typeobj15=document.getElementById('Options');
	var typeobj16=document.getElementById('itmDesc');
	var typeobj17=document.getElementById('ancoMultiValueDesc');
	var typeobj18=document.getElementById('ancoSortNo');
	var ancoDataType = document.getElementById("ancoDataType");
	var ANCODataFormat=document.getElementById('ANCODataFormat');
	var ANCOFormatField= document.getElementById("ANCOFormatField");
	
	
	var ANCOTemplateAncoDr = document.getElementById("ANCOTemplateAncoDr");
	var ANCOTemplateAncoDrID= document.getElementById("ANCOTemplateAncoDrID");
	var ANCOTemplateSubAncoDr = document.getElementById("ANCOTemplateSubAncoDr");
	var ANCOTemplateSubAncoDrID= document.getElementById("ANCOTemplateSubAncoDrID");

    if (selectRow==preRowInd){
	 typeobj.value="";
	 typeobj1.value="";
	 typeobj2.value="";
	 typeobj3.value="";
	 typeobj4.value="";
	 typeobj5.value="";
	 typeobj6.value="";
	 typeobj7.value="";
	 typeobj8.value="";
	 typeobj9.value="";
	 //wxl
	 typeobj10.value="";
	 typeobj11.value="";
	 typeobj12.value="";
	 typeobj13.value="";
	 typeobj14.value="";  
	 typeobj15.value="";  
	 if (typeobj16) typeobj16.value="";  
	 if (typeobj17) typeobj17.value="";
	 if (typeobj18) typeobj18.value="";
	 itmId="";
	 preRowInd=0;
	 var typeobj19=document.getElementById('arcOrdSets');
	 if (typeobj19) typeobj19.value="";

	 arcosId="";
	 ID=0;
	 
	 if(ancoDataType)ancoDataType.value="";	 
    }
   else { 
  	   ClearListData("needArcimDescList");
       SetComInfo(ID);
       preRowInd=selectRow;
   }
	
	 //mfc 121227 数据格式和格式字段对应
     /*if (ANCODataFormat.value.indexOf("{")==0){
		 var DateCount=(ANCODataFormat.value.split("{")).length;
		 var FieldCount=(ANCOFormatField.value.split(";")).length;
		 if (DateCount!=(FieldCount+1))
		  alert("数据格式与格式字段个数不否");
	 }
	 //mfc 121227 选项和数据类型对应
	 if (typeobj15.value.indexOf(";")==0){		 
		 if ((ancoDataType.value!="M")&&(ancoDataType.value!="C")){
		   alert("数据类型应为单选或者多选");
		 }
	 }*/
}
	
function SetComInfo(Str)
{
	 p1=Str;
     //if (p1=='6011') alert(p1);	 
	 var UpObj=document.getElementById('GetComOrdInfo');
	 if (UpObj) {var encmeth=UpObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,p1); 
	 var RetStr=Ret.split("^");
	 //if (p1=='6011') alert(RetStr);
	 var typeobj=document.getElementById('ANCOCode');
	 if (typeobj)  typeobj.value=RetStr[0];
	 var typeobj1=document.getElementById('ANCODesc');
     if (typeobj1)  typeobj1.value=RetStr[1];
	 var typeobj2=document.getElementById('ANCOCat');
	 typeobj2.value=RetStr[2];
	 //var typeobj3=document.getElementById('needArcimDesc');
	 //typeobj3.value=RetStr[4];
	 //var typeobj4=document.getElementById('Name');
	 //typeobj4.value=RetStr[3];
	 for(var i=0;i<RetStr[3].split("~").length;i++)
	 {
		 var retId=RetStr[3].split("~");
		 var retDesc=RetStr[4].split("~");
		 var retStr=retDesc[i]+"^"+retId[i];
		 addListRow("needArcimDescList",retStr.split("^"));
	 }
	 var typeobj5=document.getElementById('CatID');
	 typeobj5.value=RetStr[5];
	 var typeobj6=document.getElementById('needItemCatId');
	 typeobj6.value=RetStr[6];
	 var typeobj7=document.getElementById('ItemCatName');
	 typeobj7.value=RetStr[7];	 	 
     var typeobj8=document.getElementById('ANCEViewCatId');
	 typeobj8.value=RetStr[8];
	 var typeobj9=document.getElementById('ANCEViewCat');
	 SelectedSet(typeobj9,RetStr[8],"|");
	 // alert(RetStr[8]);
	 //typeobj9.value=RetStr[9];
	 //wxl
	 var typeobj10=document.getElementById('UomRowId');
	 typeobj10.value=RetStr[10];
	 var typeobj11=document.getElementById('UomDesc');
	 typeobj11.value=RetStr[11];
	 var typeobj12=document.getElementById('IconRowId');
	 typeobj12.value=RetStr[12];
	 var typeobj13=document.getElementById('IconDesc');
	 typeobj13.value=RetStr[13];
	 var typeobj14=document.getElementById('ColorDesc');
	 typeobj14.value=RetStr[14];
	 var typeobj15=document.getElementById('Options');
	 typeobj15.value=RetStr[15];	 
	 var typeobj16=document.getElementById('itmDesc');
	 if (typeobj16) typeobj16.value=RetStr[16];
	 itmId=RetStr[17];
	 var typeobj17=document.getElementById('ancoMultiValueDesc');
	 if (typeobj17) typeobj17.value=RetStr[18];
	 var typeobj18=document.getElementById('ancoSortNo');
	 if (typeobj18) typeobj18.value=RetStr[19];
	 arcosId=RetStr[20];
	 var typeobj19=document.getElementById('arcOrdSets');
	 if (typeobj19) typeobj19.value=RetStr[21];
	 var ancoDataType = document.getElementById("ancoDataType");
	 if(ancoDataType) ancoDataType.value = RetStr[22];	 
     // whl 20120420
	 var typeobj20=document.getElementById('ANCOMax');
	 if (typeobj20) typeobj20.value=RetStr[26];
	 var typeobj21=document.getElementById('ANCOMin');
	 if (typeobj21) typeobj21.value=RetStr[27];
	 var typeobj22=document.getElementById('ANCOImpossibleMax');
	 if (typeobj22) typeobj22.value=RetStr[28];
	 var typeobj23=document.getElementById('ANCOImpossibleMin');
	 if (typeobj23) typeobj23.value=RetStr[29];
	 var typeobj24 = document.getElementById("ANCOMainAncoDrId");
	 if(typeobj24) typeobj24.value = RetStr[30];
	  var typeobj25=document.getElementById('ANCODataField');
	 if (typeobj25) typeobj25.value=RetStr[31];
	 var typeobj26=document.getElementById('ANCODataFormat');
	 if (typeobj26) typeobj26.value=RetStr[32];	
	 var typeobj27=document.getElementById('ANCOFormatField');
	 if (typeobj27) typeobj27.value=RetStr[33];	
	 //alert(RetStr[33])
	 var typeobj28=document.getElementById('ANCOMainAncoDr');
	 if (typeobj28) typeobj28.value=RetStr[34];	
	 
	var ANCOTemplateAncoDrID = document.getElementById("ANCOTemplateAncoDrID");
	if (ANCOTemplateAncoDrID) ANCOTemplateAncoDrID.value=RetStr[35];	
	var ANCOTemplateAncoDr= document.getElementById("ANCOTemplateAncoDr");
	  if (ANCOTemplateAncoDr) ANCOTemplateAncoDr.value=RetStr[36];
	  
	//var ANCOTemplateSubAncoDrID = document.getElementById("ANCOTemplateSubAncoDrID");
	//if (ANCOTemplateSubAncoDrID) ANCOTemplateSubAncoDrID.value=RetStr[37];	
	///var ANCOTemplateSubAncoDr= document.getElementById("ANCOTemplateSubAncoDr");
	//if (ANCOTemplateSubAncoDr) ANCOTemplateSubAncoDr.value=RetStr[38];	
	var valueIdList=RetStr[37].split("|");
	var valueList=RetStr[38].split("|");	
	var objList=document.getElementById('ANCOTemplateSubAncoList');
	if (objList)
	{
		objList.length=0;  
	    for (var i=0;i<valueIdList.length;i++){ 
    	  var objSelected = new Option(valueList[i],valueIdList[i]);
		  objList.options[objList.options.length]=objSelected;
	    }
	}
	 //alert(RetStr);
}
function ItemCatBlue()
{
	var obj=document.getElementById('ItemCatName');
	if ((obj)&&(obj.value=="")) document.getElementById('needItemCatId').value="";
}

	//ypz begin
function FormatColor()//add 0 before color value
{
	var obj=document.getElementById('ColorDesc'); 
	if (obj) {
		obj.value=((obj.value.length<6)?"000000".substring(0,6-obj.value.length):"") + obj.value;
	}
}
function HexFilter()//only hex input
{
	var obj=document.getElementById('ColorDesc'); 
	if (obj) {if (obj.value.length>5) {window.event.keyCode = 0;return;}};
	if ( !(((window.event.keyCode >= 48) && (window.event.keyCode <= 57)) 
		|| ((window.event.keyCode >= 65) && (window.event.keyCode <= 70))
		|| ((window.event.keyCode >= 97) && (window.event.keyCode <= 102))
		|| (window.event.keyCode == 13)))
	{
		window.event.keyCode = 0 ;
	}
}
function selitem(selbox,delimStr)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			if (selbox.options[i].selected)
			{   //alert(tmpList.length+" //"+tmpList)
			    tmpList[tmpList.length]=selbox.options[i].value
			}
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join(delimStr);
  return Str
}
function SelectedSet(selObj,indStr,delim) 
{//查询条件设置
	var tmpList=new Array();
	for(i=0;i<selObj.options.length;i++)
	{
		selObj.options[i].selected=false;
	}
	tmpList=indStr.split(delim)
	for(j=0;j<tmpList.length;j++)
	{
		for(i=0;i<selObj.options.length;i++)
		{
			if (selObj.options[i].value==tmpList[j])
		    {
			    selObj.options[i].selected=true;break
		    }
		}
	}
}
function Color_click()//call color panel
{
	var curColor="000000"
	var obj=document.getElementById('ColorDesc'); 
    if (obj) curColor=obj.value;
	/*//window.open('dhccolorpanel.csp', 'Sample', 'toolbar=no,location=yes,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=1,height=1,left=0,top=0');	
	////window.open('dhccolorpanel.csp', 'Sample', 'toolbar=no,location=yes,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=48,height=80,left=10000,top=10000');	//ok
	//showModelessDialog("dhccolorpanel.csp","window", "status:false;dialogWidth:0px;dialogHeight:0px;edge:Raised; enter:no; help: No; resizable: No; status: No;dialogTop:100px;dialogLeft:100px");
	var diaRet=showModalDialog("dhccolorpanel.csp",tmpColor, "status:false;dialogWidth:0px;dialogHeight:0px;edge:Raised; enter:no; help: No; resizable: No; status: No");
	if (obj) obj.value =diaRet; */
	
    var tempColor=window.dialogArguments;
    var Hcolor = dlgHelper.ChooseColorDlg(curColor).toString(16);
    tempColor=((Hcolor.length<6)?"000000".substring(0,6-Hcolor.length):"") + Hcolor;
    if (obj) obj.value=tempColor;
    //alert("tempColor="+tempColor);
    window.close();
}
//ypz end
function ArcimDescList_Dublclick()
{
	list_Dublclick("needArcimDescList");
}
function list_Dublclick(elementName)
{
  	var listObj=document.getElementById(elementName);
  	var objSelected=listObj.selectedIndex;
  	if(objSelected == -1) return;
  	listObj.remove(objSelected);
}
function addListRow(elementName,dataValue)
{
	var itemValue=dataValue;
	if(itemValue[0] == "" || itemValue[1] == "") return;
    var objSelected = new Option(itemValue[0], itemValue[1]);
	var listObj=document.getElementById(elementName);
	listObj.options[listObj.options.length]=objSelected;
}
/*
function InitListRow(elementName,dataValue)
{
	var listData=dataValue.split("^");
	var objList=document.getElementById(elementName);
	if(objList){
		for (var i=0;i<listData.length;i++)
			{
			if (listData[i]!="")
			{
				var listRowItem=listData[i].split("!");
				var sel=new Option(listRowItem[0],listRowItem[1]);
				objList.options[objList.options.length]=sel;
			}
		}
	}
}
*/
function GetListData(elementName)
{
	var retString
	retString=""
	var objList=document.getElementById(elementName);
	if(objList){
		for (var i=0;i<objList.options.length;i++)
	   	{
		   if (objList.options[i].value!="")
		   {
			   if(retString==""){
				   retString=objList.options[i].value
			   }
			   else{
				   retString=retString+"~"+objList.options[i].value
			   }
		   }
		}
	}
	return retString
}
function ArcimDescKeyDown()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=117;
		arcimDesc_lookuphandler();
	}
}
function ClearListData(elementName)
{
	var listvalue=GetListData(elementName);
	var listObj=document.getElementById(elementName);
	
	for(var i=0;i<listvalue.split("~").length;i++)
	{
	  	listObj.remove(0);
	}
}

function SetDataField(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("ANCODataField");
	Obj.value=obj[0];
	var Obj=document.getElementById("UomRowId");
	Obj.value=obj[1];	
	}

function isNumber(oNum) 
{ 
  if(!oNum) return false; 
  var strP=/^\d+(\.\d+)?$/; 
  if(!strP.test(oNum)) return false; 
  try{ 
  if(parseFloat(oNum)!=oNum) return false; 
  } 
  catch(ex) 
  { 
   return false; 
  } 
  return true; 
   }
   
function CheckData()
{
	 var ANCOMaxobj=document.getElementById('ANCOMax');
	 if (ANCOMaxobj) var ANCOMax=ANCOMaxobj.value;
	 var ANCOMinobj=document.getElementById('ANCOMin');
	 if (ANCOMinobj) var ANCOMin=ANCOMinobj.value;
	 var ANCOImpossibleMaxobj=document.getElementById('ANCOImpossibleMax');
	 if (ANCOImpossibleMaxobj) var ANCOImpossibleMax=ANCOImpossibleMaxobj.value;
	 var ANCOImpossibleMinobj=document.getElementById('ANCOImpossibleMin');
	 if (ANCOImpossibleMinobj) var ANCOImpossibleMin=ANCOImpossibleMinobj.value;
     var ANCODataFieldobj=document.getElementById('ANCODataField');
	 if (ANCODataFieldobj) var ANCODataField=ANCODataFieldobj.value;
     if(ANCODataField=="")
     {
	  alert("请选择对应字段!") 
	  ANCODataFieldobj.focus();
	  ANCODataFieldobj.value="";
	  return false;
	 }
     if(ANCOMaxobj.value!="")
     {if(!isNumber(ANCOMax))
       {
	    alert("请输入数字!")
		ANCOMaxobj.focus();
		ANCOMaxobj.value="";
	     return false;
	   }
     }
     if(ANCOMinobj.value!="")
     {
      if(!isNumber(ANCOMin))
      {
	    alert("请输入数字!")
		ANCOMinobj.focus();
		ANCOMinobj.value="";	
	    return false;
	  }
	}
	if(ANCOImpossibleMaxobj.value!="")
	{
     if(!isNumber(ANCOImpossibleMax))
      {
	    alert("请输入数字!")
		ANCOImpossibleMaxobj.focus();
		ANCOImpossibleMaxobj.value="";	
	    return false;
	   }
	}
	if(ANCOImpossibleMinobj.value!="")
	{
     if(!isNumber(ANCOImpossibleMin))
     {
	    alert("请输入数字!")
		ANCOImpossibleMinobj.focus();
		ANCOImpossibleMinobj.value="";	
	     return false;
	 }
	}
	if(ANCOImpossibleMaxobj.value!=""&&ANCOImpossibleMinobj.value!="")
	{
		if(!numberCompare(ANCOImpossibleMaxobj.value,ANCOImpossibleMinobj.value))
		{
			alert("极大值不能大于极小值请重新输入!");
			
			ANCOImpossibleMaxobj.value="";
			ANCOImpossibleMinobj.value="";
			ANCOImpossibleMaxobj.foucs();
			return false;
			}

		}	
	if(ANCOMaxobj.value!=""&&ANCOMinobj.value!="")
	{
		if(!numberCompare(ANCOMaxobj.value,ANCOMinobj.value))
		{
			alert("最大值不能大于最小值请重新输入!");
			ANCOMaxobj.value="";
			ANCOMinobj.value="";
			ANCOMaxobj.foucs();
			return false;
			}

		}
	return true;
}

function numberCompare(num1,num2)
{
	if(parseFloat(num1)>parseFloat(num2))
	{
		return true;
		}
		else {return false;}
	}
function AnaMethodList_Dublclick()//delete anaMethod
{
	var obj=document.getElementById("ANCOTemplateSubAncoList");
	var a=obj.selectedIndex;
	obj.remove(a) ;
}
function LookANCOTemplateSubAncoDr()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	ANCOTemplateSubAncoDr_lookuphandler();
	}
}
document.body.onload = BodyLoadHandler;
