
/*
DHCFavOrderSets.Edit.js   zhouzq 2005.11.13
*/
var SelectedRow=0;
var HospitalCode="";
var DefaultCatID
var DefaultSubCatID
var ForPower;
var SelectedARCOSRowid="";
var SelectedARCode="";
window.returnValue="" //lxz初始化
function BodyLoadHandler(){
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	GroupID=session['LOGON.GROUPID'];
	CTLOCID=session['LOGON.CTLOCID'];
	
	var SaveAsUserObj=document.getElementById("SaveAsUser");
	
	if  (SaveAsUserObj)
	{
	 SaveAsUserObj.disabled='true';
	 SaveAsUserObj.onclick="";
	}
	//if ((SaveAsUserObj)&&(GuserCode!='10385'))
	//{
	 // SaveAsUserObj.style.display="none";
	//}
	//取到登陆的组
	var obj=document.getElementById("GetDocMedUnit");
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	var DocMedUnit=cspRunServerMethod(encmeth,Guser,CTLOCID);
	var obj=document.getElementById("DocMedUnit");
	if (obj) obj.value=DocMedUnit;
	
	var Ordertable=document.getElementById("tUDHCFavOrderSets_Edit");
	var OrdertableWidth;
	var categoryobj=document.getElementById("Category");
	if (categoryobj)
	{
		var categorywidth=categoryobj.style.width;
		var ARCOSordCat=Ordertable.getElementsByTagName("tbody")[0].getElementsByTagName("tr")[0].getElementsByTagName("td")[1]   //Ordertable.childNodes[0].childNodes[0].childNodes[1];
		if (categorywidth!="")
		{
			ARCOSordCat.style.width=parseInt(categorywidth)+4+"px";
		    categoryobj.parentNode.style.width=parseInt(categorywidth)+12+"px";
		    OrdertableWidth=parseInt(categorywidth)+4
		}
		
	}
	
	var Codeobj=document.getElementById("Code");
	if (Codeobj)
	{
		var CodeWidth=Codeobj.style.width;;
		var ARCOSCode=Ordertable.getElementsByTagName("tbody")[0].getElementsByTagName("tr")[0].getElementsByTagName("td")[3]    //Ordertable.childNodes[1].childNodes[0].childNodes[4];
		if (Codeobj.style.width!="")
		{
			ARCOSCode.style.width=parseInt(CodeWidth)+4+"px";
			Codeobj.parentNode.style.width=parseInt(CodeWidth)+4+"px";
			OrdertableWidth+=parseInt(CodeWidth)+4
			
		}
		else
		{
			ARCOSCode.style.width="150px";
			Codeobj.style.width="146px";
		    Codeobj.parentNode.style.width="150px";
		    OrdertableWidth+=150;
		}
	} 
	var Descobj=document.getElementById("Desc");
	if (Descobj)
	{
		var DescWidth=Descobj.style.width;
		var ARCOSDesc=Ordertable.getElementsByTagName("tbody")[0].getElementsByTagName("tr")[0].getElementsByTagName("td")[4];
		if (DescWidth!="")
		{
			ARCOSDesc.style.width=parseInt(DescWidth)+"px";
			Descobj.parentNode.style.width=parseInt(DescWidth)+4+"px";
			OrdertableWidth+=parseInt(DescWidth)+4;
		}
		else
		{
			ARCOSDesc.style.width="150px";
			Descobj.style.width="146px";
		    Descobj.parentNode.style.width="172px";
		    OrdertableWidth+=150;
		}
	}
	
	var Aliasobj=document.getElementById("Alias");
	if (Aliasobj)
	{
		var AliasWidth=Aliasobj.style.width;
		var ARCOSAlias=Ordertable.getElementsByTagName("tbody")[0].getElementsByTagName("tr")[0].getElementsByTagName("td")[5];
		if(Aliasobj.style.width!="")
		{
			ARCOSAlias.style.width=AliasWidth;
			Aliasobj.parentNode.style.width=AliasWidth;
			OrdertableWidth+=parseInt(AliasWidth);
		}
		else
		{
          ARCOSAlias.style.width="146px";
          Aliasobj.parentNode.style.width="150px";
          OrdertableWidth+=150;
		}
	
	}
	
	var csubobj=document.getElementById("SubCategory");
	if (csubobj) {
		csubobj.multiple=false;
		csubobj.size=1
		var csuWidth=csubobj.style.width;
		var ARCOSOrdSubCat=Ordertable.getElementsByTagName("tbody")[0].getElementsByTagName("tr")[0].getElementsByTagName("td")[2]   //Ordertable.childNodes[0].childNodes[0].childNodes[2];	
		if (csuWidth!="")
		{
			ARCOSOrdSubCat.style.width=parseInt(csuWidth)+4+"px";
		    csubobj.parentNode.style.width=parseInt(csuWidth)+4+"px";
		    OrdertableWidth+=parseInt(csuWidth)+4;
		}
		else
		{
			ARCOSOrdSubCat.style.width="150px";
		    csubobj.parentNode.style.width="150px";
		    OrdertableWidth+=150;
		}
	}
	//csubobj.parentNode.parentNode.parentNode.parentNode.Width=OrdertableWidth+180+"px";
	
	//csubobj.parentNode.parentNode.parentNode.parentNode.style.width=OrdertableWidth+180+"px";
	
	
	//条件
	var Conditionesobj=document.getElementById("Conditiones");
	if (Conditionesobj) {
		Conditionesobj.multiple=false;
		Conditionesobj.size=1
	}
	InitConditiones();
	var cobj=document.getElementById("Category");
	if (cobj) {
		cobj.onchange=CategoryChangeHandler;
		cobj.multiple=false;
		cobj.size=1
		var NewIndex=cobj.length;
		cobj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("GetCategoryList")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			if (cspRunServerMethod(encmeth,'SetCategoryList')!='0') {}
		}
		for(var j=0;j<cobj.length;j++){
			if (cobj.options[j].text==t['C_Orderset']){
				cobj.selectedIndex=j;
				CategoryChangeHandler();
				cobj.disabled=true;
				for(var i=0;i<csubobj.length;i++){
					if (csubobj.options[i].text==t['C_PersonOrderset']){
						csubobj.selectedIndex=i;
						//csubobj.disabled=true;
						break;
					}
				}
				break;
			}
		}
	}
	
	
	
	var obj=document.getElementById("status");
	if (obj) var statu=obj.value;
	var obj=document.getElementById("UserForQuery");
	if (obj){
		if (statu=="")
		{obj.style.display ="none"}
		}
	var obj=document.getElementById("ld53777iUserForQuery");
	if (obj){
		if (statu=="")
		{obj.style.display ="none"}
		}
	var obj=document.getElementById("Add");
	if (obj) obj.onclick=AddClickHandler;
	var obj=document.getElementById("Delete");
	if (obj) obj.onclick=DeleteClickHandler;
	var obj=document.getElementById("Update");
	if (obj) obj.onclick=UpdateClickHandler;
	var obj=document.getElementById("Detail");
	if (obj) 
	{
		//obj.onclick=DetailClickHandler;
		
		obj.onclick=function ()
		{
			return false;
			}
		obj.style.display="none";
	}
	var obj=document.getElementById("Hospital");
	if (obj) {
		var Hospital=obj.value;
		HospitalCode=mPiece(Hospital,"^",0);
	}
	//FindData();
	var obj=document.getElementById("Code");
	if (obj) {
		if (HospitalCode=="NB"){obj.disabled=true}
	}
  	ResetButton(0);
 	SelectedRow=0

}


function InitConditiones()
{   
	var obj=document.getElementById("DocMedUnit");
	if(obj) DocMedUnit=obj.value;
	DHCWebD_ClearAllListA("Conditiones"); 
	var encmeth=DHCWebD_GetObjValue("GetConditiones"); 
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","Conditiones",ForPower,DocMedUnit);
		var conditions=document.getElementById("Conditiones");
		var searchConditions=document.getElementById("SearchConditiones");
		for (var i=0;i<conditions.length;i++)
		{
		  if  ((searchConditions)&&(conditions.options[i].value==searchConditions.value)) {
		  conditions.value=conditions.options[i].value;
		  break;
		  }		  
		}
	
	}
}

function FindData() {
	
	var obj=document.getElementById('UserID');
	if (obj) var UserID=obj.value;
	var GetPrescItems=document.getElementById('FindData');
	if (GetPrescItems) {var encmeth=GetPrescItems.value;} else {var encmeth=''};
	if (encmeth!="") {
		if (cspRunServerMethod(encmeth,'AddTabRow',UserID)=='0') {
			obj.className='';
		}
	}
}

function AddRowToList(objtbl) {
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	//objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
			//rowitems[j].innerText="";
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
}

function DeleteTabRow(selectrow){
	var objtbl=document.getElementById('tUDHCFavOrderSets_Edit');
	var rows=objtbl.rows.length;
	if (rows>2){
		objtbl.deleteRow(selectrow);
	}else{
		var objlastrow=objtbl.rows[rows-1];
		var rowitems=objlastrow.all; //IE only
		if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			if (rowitems[j].id) {
				var Id=rowitems[j].id;
				var arrId=Id.split("z");
				//arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
				SetColumnData(arrId[0],arrId[1]," ")
			}
		}
	 	ResetButton(0);
	}
}

function AddTabRow(value) {
	
	try {
		if (value==""){return;}	
		var objtbl=document.getElementById('tUDHCFavOrderSets_Edit');
		//alert(objtbl)
	    var rows=objtbl.rows.length;
	    //alert(rows);return;
	    if (rows==2){
		    var LastRow=rows - 1;
		    var Row=GetRow(LastRow);
     		var FavRowid=GetColumnData("FavRowid",1);
			if ((FavRowid!="")&&(FavRowid!=" ")){AddRowToList(objtbl);}
	    //}else{AddRowToList(objtbl)}
	  	}
	    
	   
 		var rows=objtbl.rows.length;
		var LastRow=rows - 1;
        var Row=GetRow(LastRow);
		var Split_Value=value.split("^")
		
        SetColumnData("ARCOSRowid",Row,Split_Value[0]);
        SetColumnData("ARCOSCode",Row,Split_Value[1]);
        SetColumnData("ARCOSDesc",Row,Split_Value[2]);
        SetColumnData("ARCOSOrdCat",Row,Split_Value[3]);
        SetColumnData("ARCOSOrdSubCat",Row,Split_Value[4]);
        SetColumnData("ARCOSEffDateFrom",Row,Split_Value[5]);
        SetColumnData("ARCOSOrdCatDR",Row,Split_Value[6]);
        SetColumnData("ARCOSOrdSubCatDR",Row,Split_Value[7]);
        SetColumnData("FavRowid",Row,Split_Value[8]);
        SetColumnData("ARCOSAlias",Row,Split_Value[9]);
        
        SetColumnData("FavUserDesc",Row,Split_Value[10]);
        SetColumnData("FavDepDesc",Row,Split_Value[11]);
        SetColumnData("MedUnitDesc",Row,Split_Value[12]);
        //SetColumnData("FavUserDr",Row,Split_Value[12]);
        //SetColumnData("FavDepDr",Row,Split_Value[13]);
        //SetColumnData("MedUnit",Row,Split_Value[14]);
       
        
	}catch(e) {alert(e.message);}
}

function UpdateTabRow(value) {
	try {
			
		if (value!=""){	
			var objtbl=document.getElementById('tUDHCFavOrderSets_Edit');
	 		var rows=objtbl.rows.length;
	 		
			if (rows==1) return ;
			if (SelectedRow==0) return ;
			var RowObj=objtbl.rows[SelectedRow];
			var rowitems=RowObj.all;
			if (!rowitems) rowitems=RowObj.getElementsByTagName("label");
			for (var j=0;j<rowitems.length;j++) {
				if (rowitems[j].id) {
					var Id=rowitems[j].id;
					var arrId=Id.split("z");
					var Row=arrId[arrId.length-1];
				}
			}
			
			var rowitems=RowObj.all;
			if (!rowitems) rowitems=RowObj.getElementsByTagName("label");
			for (var j=0;j<rowitems.length;j++) {
				if (rowitems[j].id) {
					var Id=rowitems[j].id;
					var arrId=Id.split("z");
					var Row=arrId[arrId.length-1];
				}
			}

			var Split_Value=value.split("^")
	        //ARCOSRowid:ARCOSCode:ARCOSDesc:ARCOSOrdCat:ARCOSOrdSubCat:ARCOSEffDateFrom
	        //ARCOSOrdCatDR:ARCOSOrdSubCatDR:FavRowid
	        //
	        SetColumnData("ARCOSRowid",Row,Split_Value[0]);
	        SetColumnData("ARCOSCode",Row,Split_Value[1]);
	        SetColumnData("ARCOSDesc",Row,Split_Value[2]);
	        SetColumnData("ARCOSOrdCat",Row,Split_Value[3]);
	        SetColumnData("ARCOSOrdSubCat",Row,Split_Value[4]);
	        SetColumnData("ARCOSEffDateFrom",Row,Split_Value[5]);
	        SetColumnData("ARCOSOrdCatDR",Row,Split_Value[6]);
	        SetColumnData("ARCOSOrdSubCatDR",Row,Split_Value[7]);
	        SetColumnData("FavRowid",Row,Split_Value[8]);
	        SetColumnData("ARCOSAlias",Row,Split_Value[9]);
	        SetColumnData("FavUserDesc",Row,Split_Value[10]);
        	SetColumnData("FavDepDesc",Row,Split_Value[11]);
        	SetColumnData("FavUserDr",Row,Split_Value[12]);
        	SetColumnData("FavDepDr",Row,Split_Value[13]);
        	SetColumnData("MedUnit",Row,Split_Value[14]);
        	SetColumnData("MedUnitDesc",Row,Split_Value[15]);
        	
		}
	} catch(e) {alert(e.message)};
}

function DisableAddButton(Disable){
	//alert("in DisableOrderDetailsButton Disable="+Disable);
	// disable Order Details button till the alert screen update or closes.
	// PeterC LOG 42321 16/02/04
	var odObj=document.getElementById("Add");
	if ((odObj)&&(Disable=="1")) {
		odObj.disabled=true;
		odObj.onclick="";
	}
	if ((odObj)&&(Disable=="0")) {
		odObj.disabled=false;
		odObj.onclick=AddClickHandler;
	}
}
function DisableDeleteButton(Disable){
	//alert("in DisableOrderDetailsButton Disable="+Disable);
	// disable Order Details button till the alert screen update or closes.
	// PeterC LOG 42321 16/02/04
	var odObj=document.getElementById("Delete");
	if ((odObj)&&(Disable=="1")) {
		odObj.disabled=true;
		odObj.onclick="";
	}
	if ((odObj)&&(Disable=="0")) {
		odObj.disabled=false;
		odObj.onclick=DeleteClickHandler;
	}
}
function DisableUpdateButton(Disable){
	//alert("in DisableOrderDetailsButton Disable="+Disable);
	// disable Order Details button till the alert screen update or closes.
	// PeterC LOG 42321 16/02/04
	var odObj=document.getElementById("Update");
	if ((odObj)&&(Disable=="1")) {
		/*
		odObj.disabled=true;
		odObj.style.color='darkgray';
		odObj.style.backgroundColor='';
		odObj.onclick="";
		*/
		DHCC_DisBtn(odObj);
	}
	if ((odObj)&&(Disable=="0")) {
		/*
		odObj.disabled=false;
		odObj.style.color='black';
		odObj.style.backgroundColor='LightGrey';
		odObj.onclick=UpdateClickHandler;
		*/
		DHCC_AvailabilityBtn(odObj);
		odObj.onclick=UpdateClickHandler;
	}
}
function DisableDetailButton(Disable){
	//alert("in DisableOrderDetailsButton Disable="+Disable);
	// disable Order Details button till the alert screen update or closes.
	// PeterC LOG 42321 16/02/04
	var odObj=document.getElementById("Detail");
	if ((odObj)&&(Disable=="1")) {
		odObj.disabled=true;
		odObj.onclick="";
	}
	if ((odObj)&&(Disable=="0")) {
		odObj.disabled=false;
		odObj.onclick=DetailClickHandler;
	}
}


function SetValue(name,value){
	var obj=document.getElementById(name);
	if (obj) {
		if (obj.tagName=="LABEL") {obj.innerText=value;} else {obj.value=value}
	}
}

function GetRow(Rowindex){
	var objtbl=document.getElementById('tUDHCFavOrderSets_Edit');
	var RowObj=objtbl.rows[Rowindex];
	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("label");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	
	return Row;
}
function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj.tagName=='LABEL'){
		return CellObj.innerText;
	}else{
		if (CellObj.type=="checkbox"){
			return CellObj.checked;
		}else{
			return CellObj.value;}
		}
	return "";
}
function SetColumnData(ColName,Row,Val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
	  //alert(CellObj.id+"^"+CellObj.tagName);
	  if (CellObj.tagName=='LABEL'){
	  	CellObj.innerText=Val;
	  }else{
			if (CellObj.type=="checkbox"){
				CellObj.checked=Val;
			}else{
				CellObj.value=Val;
			}
		}
	}
}
function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tUDHCFavOrderSets_Edit');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (eSrc && (eSrc.id.indexOf("OrdSetPrice")!=-1)) {
		var detailframe=parent.frames["detail"];
		if (detailframe){
			/*
			var AllItems=detailframe.document.getElementsByTagName("table");
			for (var i=0;i<AllItems.length;i++) {
				AllItems[i].parentNode.removeChild(AllItems[i]);
			}
			*/
			detailframe.document.body.innerHTML="";
		}
		if (selectrow>0) {if (selectrow%2==0) {rowObj.className="RowEven";} else {rowObj.className="RowOdd";}}
		SelectedRow=0;
		return websys_cancel();
	}
	var Row=GetRow(selectrow);	
	var ARCOSRowid=GetColumnData('ARCOSRowid',Row);
	if (selectrow!=SelectedRow){
		SelectedARCOSRowid=ARCOSRowid
		var ARCOSCode=GetColumnData('ARCOSCode',Row);
		SelectedARCode=ARCOSCode;
		var ARCOSDesc=GetColumnData('ARCOSDesc',Row);
        var Split_Desc=ARCOSDesc.split("-");
        if (Split_Desc.length==2) {ARCOSDesc=Split_Desc[1]}
		else if(Split_Desc.length>2) {
		Split_Desc.shift();
		ARCOSDesc=Split_Desc.join("-");
		}
	
		var CatID=GetColumnData('ARCOSOrdCatDR',Row);
		var ARCOSAlias=GetColumnData('ARCOSAlias',Row);
		var FavUserDesc=GetColumnData('FavUserDesc',Row);
		var FavDepDesc=GetColumnData('FavDepDesc',Row);
		var FavUserDr=GetColumnData('FavUserDr',Row);
		var FavDepDr=GetColumnData('FavDepDr',Row);
		var MedUnitDr=GetColumnData('MedUnit',Row);
		var saveToUser=document.getElementById("SaveAsUser");
		if  ((FavDepDr!="")&&(saveToUser))
		{
		saveToUser.disabled=false;
		saveToUser.onclick=SaveAsUserClickHandler;
        }
		else
		{
		saveToUser.disabled=true;
		saveToUser.onclick="";
		}
		var MedUnit=GetColumnData('MedUnit',Row);
		var MedUnit=GetColumnData('MedUnitDesc',Row);
		  
	    
	   
		SetValue('Code',ARCOSCode);
		SetValue('Desc',ARCOSDesc);
		SetValue('Category',CatID);
		SetValue('Alias',ARCOSAlias);
		
		var  obj=document.getElementById('DocMedUnit');
		if (obj){obj.value=MedUnit;}
		
		var  obj=document.getElementById('UserForQuery');
		if (obj){obj.value=FavUserDesc;}
		var  obj=document.getElementById('LocDesc');
		if (obj){obj.value=FavDepDesc;}
		
		//SetValue('UserForQuery',FavUserDr);
		//SetValue('LocDesc',FavDepDr);
		SetValue('TFavUserDr',FavUserDr);
		SetValue('ForQueryUserID',FavUserDr);
		SetValue('ForQueryLocID',FavDepDr);
	
		
	
		//combo_UserList.setComboText(FavUserDesc);
		//combo_DeptList.setComboText(FavDepDesc);
		if (CatID!=''){
			SetSubCategory(CatID);
			var obj=document.getElementById('ARCOSOrdSubCatDRz'+Row);
			if (obj) SetValue('SubCategory',obj.value);
		}
		if(FavUserDr!=""){
			SetValue('Conditiones',1);
		}
		if(FavDepDr!=""){
			SetValue('Conditiones',2);
			
		}
		if(MedUnitDr!=""){
			SetValue('Conditiones',4);
			
		}
		SelectedRow = selectrow;
		ResetButton(1);
		if (ARCOSRowid!='') {
			var detailframe=parent.frames["detail"];
			if (detailframe){
		    	detailframe.location="websys.default.csp?WEBSYS.TCOMPONENT=UDHCARCOrderSetItem.Edit&UserID="+session['LOGON.USERID']+"&OSID="+ARCOSRowid;
			}
		}
		else
		{
			var detailframe=parent.frames["detail"];
			if (detailframe){
		    	detailframe.location="websys.default.csp?WEBSYS.TCOMPONENT=UDHCARCOrderSetItem.Edit";
			}
		}

	}else{
		SelectedRow=0;
		ResetButton(0)
		if (ARCOSRowid!='') {
			var detailframe=parent.frames["detail"];
			if (detailframe){
		    	detailframe.location="websys.default.csp?WEBSYS.TCOMPONENT=UDHCARCOrderSetItem.Edit&UserID="+session['LOGON.USERID']+"&OSID=";
			}
		}
	}
}

function AddClickHandler(saveToUser){
		
//确保是选择状态再去取值
var ConditionesValue=""
var ConditionesDesc=""	
var obj=document.getElementById("Conditiones");
if (obj.selectedIndex!=-1)
{
ConditionesValue=obj.options[obj.selectedIndex].value;
ConditionesDesc=obj.options[obj.selectedIndex].text;
}
if (ConditionesValue=="")
{	alert("请选择保存用户类型")
	websys_setfocus('Conditiones');
	return;
}

	
	var objtbl=document.getElementById('tUDHCFavOrderSets_Edit');
	var row=objtbl.rows.length;
	if (row>22){
		//alert(t['MaxRow']);
		//return;
	}
	
	var obj=document.getElementById("Code");
	if (obj) var ARCOSCode=obj.value;
	/*
	if (ARCOSCode=='') {
		alert(t['NoCode']);
		websys_setfocus('Code');
		return;
	}
	*/
	

	var obj=document.getElementById("Desc");
	if (obj) var ARCOSDesc=obj.value;
	if (ARCOSDesc=='') {
		alert(t['NoDesc']);
		websys_setfocus('Desc');
		return;
	}
//alert("ARCOSDesc:"+ARCOSDesc)
	var obj=document.getElementById("Alias");
	if (obj) var ARCOSAlias=obj.value;
	if (ARCOSAlias=='') {
		alert('别名不存在');
		websys_setfocus('Alias');
		return;
	}
	
	var ARCOSCat="";
	var obj=document.getElementById("Category");
	if (obj) {
		ARCOSCatID=obj.value;
		if (obj.selectedIndex!=-1) ARCOSCat=obj.options[obj.selectedIndex].text;
	}
	
	var ARCOSSubCat="";
	var obj=document.getElementById("SubCategory");
	if (obj) {
		var ARCOSSubCatID=obj.value;
		if (obj.selectedIndex!=-1) ARCOSSubCat=obj.options[obj.selectedIndex].text;
	}
	var obj=document.getElementById("StartDate");
	if (obj) var ARCOSEffDateFrom=obj.value;
	
	var obj=document.getElementById("UserID");
	if (obj) var UserID=obj.value;
	if (UserID=='') {
		alert(t['NoUserID']);
		return;
	}
	//插入医嘱套
	var GetPrescList=document.getElementById("InsertARCOS")
	if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
	if (encmeth!="") {
		if (HospitalCode=="NB"){
			ARCOSDesc=session['LOGON.USERNAME']+"-"+ARCOSDesc;
		}else if(HospitalCode=='SHSDFYY'){
			ARCOSDesc=ARCOSDesc;
		}else{
			ARCOSDesc=session['LOGON.USERCODE']+"-"+ARCOSDesc;
		}
	
		Guser=session['LOGON.USERID']
		GuserCode=session["LOGON.USERCODE"];
		GroupID=session['LOGON.GROUPID'];
		CTLOCID=session['LOGON.CTLOCID'];
		//取组
		var obj=document.getElementById("GetDocMedUnit");
		if (obj) {var dd=obj.value} else {var encmeth=''};
		var DocMedUnit=cspRunServerMethod(dd,Guser,CTLOCID);
		//默认为个人
		if (ConditionesValue=="")   {ConditionesValue=1}
		if (ConditionesValue=="1") {var UserID=Guser; var FavDepList="";var DocMedUnit="";};
		//科室，全院医嘱套bug修改：暂时不允许code为空
		if (ConditionesValue=="2") 
		{
			var UserID="";
			var FavDepList=CTLOCID;
			var DocMedUnit="";
			if (ARCOSCode=='') {
				alert(t['NoCode']);
				websys_setfocus('Code');
				return;
				}
			}
		if (ConditionesValue=="3") 
		{
			var UserID="";
			var FavDepList="";
			var DocMedUnit="";
			if (ARCOSCode=='') {
				alert(t['NoCode']);
				websys_setfocus('Code');
				return;
				}
			}
		if (ConditionesValue=="4") {var UserID=Guser;var FavDepList="";};
		var ForQueryLocIDObj=document.getElementById("ForQueryLocID");
		
		if ((saveToUser)&&(saveToUser=="SaveToUser")&&(ForQueryLocIDObj.value!=""))   {
			var UserID=Guser; var FavDepList="";var DocMedUnit="";
			var Copyobj=document.getElementById("CopyOrdSet");
			var ret="";
			if  ((Copyobj)&&(SelectedARCOSRowid!="")) {		         
					//var ret=cspRunServerMethod(Copyobj.value,UserID,SelectedARCOSRowid,FavDepList,DocMedUnit); 
                    var ret=cspRunServerMethod(Copyobj.value,SelectedARCOSRowid,UserID,ARCOSCode+"RS",ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit)					
			   }
		   
		}else {
		
			 ret=cspRunServerMethod(encmeth,UserID,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit)
		}
		//alert(ret);
		if (ret=='-1') {
			alert(t['InsertErr']+"  您可能填写了已经使用的代码");
			return;
		}else{
				if ((saveToUser)&&(saveToUser=="SaveToUser")) {
				var ARCOSCode=SelectedARCode+"RS";
				var FavRowid=ret;
				var ARCOSRowid=SelectedARCOSRowid;
				}
				else {
			var FavRowid=mPiece(ret,String.fromCharCode(1),0);
			var ARCOSRowid=mPiece(ret,String.fromCharCode(1),1);
			var ARCOSCode=mPiece(ret,String.fromCharCode(1),2);
				}
			//alert(ARCOSRowid);
		}
	        if ((FavRowid=="")||(FavRowid==" "))
		    {
		        alert("  您可能填写了已经使用的代码");
				return;
		    }
			else {
				if (window.name!=""){
					alert(t['UpdateSuccess']);
				}
			}
			var UserDesc="" ;var DepDesc="";var MedUnitDesc="";
		
			if ((ConditionesValue=="1")||((saveToUser)&&(saveToUser=="SaveToUser"))) 
			{
				var obj=document.getElementById("GetUserNameByUserId")
				if (obj) {var encmeth=obj.value} else {var encmeth=''};
				var ret=cspRunServerMethod(encmeth,UserID);
				var UserDesc=ret
			}
			if  (ConditionesValue=="2")
			{	
				var obj=document.getElementById("GetUserLoc")
				if (obj) {var encmeth=obj.value} else {var encmeth=''};
				var ret=cspRunServerMethod(encmeth,CTLOCID);
				var DepDesc=ret
			
			}
			if (ConditionesValue=="3") 
			{}
			if (ConditionesValue=="4") 
				{
				var obj=document.getElementById("GetMedUnitDesc")
				if (obj) {var encmeth=obj.value} else {var encmeth=''};
				var ret=cspRunServerMethod(encmeth,DocMedUnit);
				var MedUnitDesc=ret
				var obj=document.getElementById("GetUserNameByUserId")
				if (obj) {var encmeth=obj.value} else {var encmeth=''};
				var ret=cspRunServerMethod(encmeth,UserID);
				var UserDesc=ret
				}

    	var value=ARCOSRowid+"^"+ARCOSCode+"^"+ARCOSDesc+"^"+ARCOSCat+"^"+ARCOSSubCat+"^"+ARCOSEffDateFrom+"^"+ARCOSCatID+"^"+ARCOSSubCatID+"^"+FavRowid+"^"+ARCOSAlias+"^"+UserDesc+"^"+DepDesc+"^"+MedUnitDesc;
		//lxz  将用模式对话框打开的窗口关闭并返回插入后的值
		if (window.name==""){
		window.returnValue=value
		window.close();
		return;
		
		}
		AddTabRow(value);
		ResetButton(0);
	}
}

function DeleteClickHandler(){
	
	
	
	var Row=GetRow(SelectedRow);
	var TFavUserDr=document.getElementById('FavUserDrz'+Row).value
	
	
	var SelRowObj=document.getElementById('FavRowidz'+Row);
	//var SelRowObj=document.getElementById('ARCOSRowidz'+Row);
	
	if(confirm(t["DeleteArcosConfirm"]))
    {
	if (SelRowObj) {
		var FavRowid=SelRowObj.value;
		//alert("FavRowid:"+FavRowid)
		//return
		var GetPrescList=document.getElementById("DeleteARCOS")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			//alert(FavRowid);
			var ret=cspRunServerMethod(encmeth,FavRowid)
			if (ret=='-1') {
			//if (FavRowid==""){
				alert(t['DeleteErr']);
			}else{
				//alert("OK");
				DeleteTabRow(SelectedRow);
   			SelectedRow=0;
 				ResetButton(0);
				var detailframe=parent.frames["detail"];
				if (detailframe){
			    	detailframe.location="websys.default.csp?WEBSYS.TCOMPONENT=UDHCARCOrderSetItem.Edit&UserID="+session['LOGON.USERID']+"&OSID=";
				}
 			}
		}
	 }
    }
	return websys_cancel();
}

function UpdateClickHandler(){

//确保是选择状态再去取值
var ConditionesValue=""
var ConditionesDesc=""	
var obj=document.getElementById("Conditiones");
if (obj.selectedIndex!=-1)
{
ConditionesValue=obj.options[obj.selectedIndex].value;
ConditionesDesc=obj.options[obj.selectedIndex].text;
}
if (ConditionesValue=="")
{	alert("请选择保存用户类型")
	websys_setfocus('Conditiones');
	return;
}
var obj=document.getElementById("Code");
	if (obj) var ARCOSCode=obj.value;
	if (ARCOSCode=='') {
		alert(t['NoCode']);
		websys_setfocus('Code');
		return;
	}
	var obj=document.getElementById("Desc");
	if (obj) var ARCOSDesc=obj.value;
	if (ARCOSDesc=='') {
		alert(t['NoDesc']);
		websys_setfocus('Desc');
		return;
	}
	var obj=document.getElementById("Alias");
	if (obj) var ARCOSAlias=obj.value;
	if (ARCOSAlias=='') {
		//alert(t['NoDesc']);
		alert('别名不存在');
		websys_setfocus('Alias');
		return;
	}
	var ARCOSCat="";
	var obj=document.getElementById("Category");
	if (obj) {
		ARCOSCatID=obj.value;
		if (obj.selectedIndex!=-1) ARCOSCat=obj.options[obj.selectedIndex].text;
	}
	var ARCOSSubCat="";
	var obj=document.getElementById("SubCategory");
	if (obj) {
		var ARCOSSubCatID=obj.value;
		if (obj.selectedIndex!=-1) ARCOSSubCat=obj.options[obj.selectedIndex].text;
	}

	var obj=document.getElementById("StartDate");
	if (obj) var ARCOSEffDateFrom=obj.value;
	var objtbl=document.getElementById('tUDHCFavOrderSets_Edit');
	var RowObj=objtbl.rows[SelectedRow];
	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("label");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	var ARCOSRowid='';
	var SelRowObj=document.getElementById('ARCOSRowidz'+Row);
	if (SelRowObj) {ARCOSRowid=SelRowObj.value;}
	if (ARCOSRowid=='') {
		//alert(t['NoRowid']);
		//return;
	}
	var FavRowid='';
	var SelRowObj=document.getElementById('FavRowidz'+Row);
	if (SelRowObj) {FavRowid=SelRowObj.value;}
	if (FavRowid=='') {
		alert(t['NoRowid']);
		return;
	}
  
    
	var GetPrescList=document.getElementById("UpdateARCOS")
	if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
	if (encmeth!="") {
		
		if (HospitalCode=="NB"){
			ARCOSDesc=session['LOGON.USERNAME']+"-"+ARCOSDesc;
		}else{
			ARCOSDesc=session['LOGON.USERCODE']+"-"+ARCOSDesc;
		}
		//取值DocMedUnit组
		Guser=session['LOGON.USERID']
		GuserCode=session["LOGON.USERCODE"];
		GroupID=session['LOGON.GROUPID'];
		CTLOCID=session['LOGON.CTLOCID'];
		var obj=document.getElementById("GetDocMedUnit");
		if (obj) {var ss=obj.value} else {var encmeth=''};
		var DocMedUnit=cspRunServerMethod(ss,Guser,CTLOCID);
		if (ConditionesValue=="1") {var UserDr=Guser; var FavDepList="";var DocMedUnit="";};
		if (ConditionesValue=="2") {var UserDr="";var FavDepList=CTLOCID;var DocMedUnit="";};
		if (ConditionesValue=="3") {var UserDr="";var FavDepList="";var DocMedUnit="";};
		if (ConditionesValue=="4") {var UserDr=Guser;var FavDepList="";};
	
		var GetPrescList=document.getElementById("UpdateARCOS");
		var Err=cspRunServerMethod(encmeth,FavRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,FavDepList,DocMedUnit,UserDr)
		if (Err=='-1') {
			alert(t['UpdateErr']);
			return;
		}
		else {
		alert(t['UpdateSuccess']);
		}
		
		var UserDesc="" ;var DepDesc="";var MedUnitDesc="";
		if (ConditionesValue=="1") 
		{
			var obj=document.getElementById("GetUserNameByUserId")
			if (obj) {var encmeth=obj.value} else {var encmeth=''};
			var ret=cspRunServerMethod(encmeth,UserDr);
			var UserDesc=ret;
		}
		if (ConditionesValue=="2") 
		{	
			var obj=document.getElementById("GetUserLoc")
			if (obj) {var encmeth=obj.value} else {var encmeth=''};
			var ret=cspRunServerMethod(encmeth,CTLOCID);
			var DepDesc=ret;
		}
		
		if (ConditionesValue=="3") 
		{}
		if (ConditionesValue=="4") 
			{
			
			var obj=document.getElementById("GetMedUnitDesc")
			if (obj) {var encmeth=obj.value} else {var encmeth=''};
			var ret=cspRunServerMethod(encmeth,DocMedUnit);
			var MedUnitDesc=ret;
			var obj=document.getElementById("GetUserNameByUserId")
			if (obj) {var encmeth=obj.value} else {var encmeth=''};
			var ret=cspRunServerMethod(encmeth,UserDr);
			var UserDesc=ret;
			}
		
        var value=ARCOSRowid+"^"+ARCOSCode+"^"+ARCOSDesc+"^"+ARCOSCat+"^"+ARCOSSubCat+"^"+ARCOSEffDateFrom+"^"+ARCOSCatID+"^"+ARCOSSubCatID+"^"+FavRowid+"^"+ARCOSAlias+"^"+UserDesc+"^"+DepDesc+"^"+""+"^"+""+"^"+""+"^"+MedUnitDesc;
	
		UpdateTabRow(value);
		
		
		
	}
	
}

function DetailClickHandler(){
    var Row=GetRow(SelectedRow);	
	//alert(Row);
	var ARCOSRowid='';
	var SelRowObj=document.getElementById('ARCOSRowidz'+Row);
	if (SelRowObj) {ARCOSRowid=SelRowObj.value;}
	if (ARCOSRowid!='') {
		var url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCARCOrderSetItem.Edit&UserID="+session['LOGON.USERID']+"&OSID="+ARCOSRowid;
		//var url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCOEOrder.CHNMEDEntry&EpisodeID="+EpisodeID+"&MRADMID="+MRADMID+"&PatientID="+PatientID;
		//websys_lu(url,true,"status=1,scrollbars=1,top=50,left=10,width=1000,height=530");
	    win=window.open(url,1,"status=1,scrollbars=1,top=50,left=10,width=1000,height=530");
	}
}

function ResetButton(ResetFlag){
	//alert(ResetFlag);
	if (ResetFlag==0){
		SetValue('Code','');
		SetValue('Desc','');
		SetValue('Alias','');
		/*
		SetValue('Category','')
		var obj=document.getElementById("SubCategory");
		if (obj) {
			ClearAllList(obj);
			var NewIndex=obj.length;
			obj.options[NewIndex] = new Option("","");
		}
		*/
		DisableAddButton(0);
		DisableDeleteButton(1);
		DisableUpdateButton(1);
		DisableDetailButton(1);
	}else{
		DisableAddButton(1);
		DisableDeleteButton(0);
		DisableUpdateButton(0);
		DisableDetailButton(0);
	}
}

function SetCategoryList(text,value){
	var obj=document.getElementById("Category");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
		if (text==t['C_Orderset']) DefaultCatID=value;
	}
}

function CategoryChangeHandler(){
	var List=document.getElementById("Category");
	var selIndex=List.selectedIndex;
	if (selIndex==-1) return;
	var CatID=List.options[selIndex].value;
	if (CatID=="") return;
	var NewIndex=List.length;
	List.options[NewIndex] = new Option("","");
	SetSubCategory(CatID);
}

function SetSubCategoryList(text,value){
	var obj=document.getElementById("SubCategory");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}
}
function SetListData(ListName,text,value){
	var obj=document.getElementById(ListName);
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}
}

function SetSubCategory(CatID){
	var obj=document.getElementById("SubCategory");
	if (obj){
		ClearAllList(obj);
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("GetSubCategoryList")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			if (cspRunServerMethod(encmeth,'SetSubCategoryList',CatID)!='0') {
			}
		}
	}
}
function LookUpCatSelect(txt) {
	//ANA 06.03.2002 Function to Return the Category ID
	var adata=txt.split("^");
	var catDesc=adata[0];
	var catID=adata[1];
	var catCode=adata[2];
	var cobj=document.getElementById("catID");
	if (cobj) cobj.value=catID;
	var scobj=document.getElementById("SubCategory");
	if (scobj) scobj.value="";
}
function LookUpSubCatSelect(txt) {
	//ANA 06.03.2002 Function to Return the SubCategory ID
	var adata=txt.split("^");
	var subCatDesc=adata[0];
	var subCatID=adata[1];
	var subCatCode=adata[2];
	var subcatobj=document.getElementById("subCatID");
	if (subcatobj) subcatobj.value=subCatID;

}
//另存为模板
function SaveAsUserClickHandler(e)
{
 AddClickHandler("SaveToUser");
 
}
document.body.onload = BodyLoadHandler;
