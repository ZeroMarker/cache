//DHCPERisOrderDetailCommon.js
///author:����
//�������ris��Ŀ�ֶ�¼��
/////����ƶ��¼���������
var vItemID=""
var vOEORIRowId=""
var vobj=""
var TempDivFlag=0
function setMounceHandly(e) {
	e.className = "RowEven";
	e.onmouseover = function () {
		this.className = "clsRowSelected";
	};
	e.onmouseout = function () {
		this.className = "RowEven";
	};
}
///author:������
///createTiame:2009-02-27
///����˫��ϸ��ѡ���¼��Ĵ�������
function setDbHandly(e) {
	e.ondblclick = function ()
	 {  
		dbClickHandly(this);
	};
}
///author:������
///createTiame:2009-02-27
//�û�˫��ϸ��ѡ��ģ���ʱ��Ĵ�������
function ODSTempOnClick(e){

	var divId=getParentDiv(e);
	var tempId=divId.substring(7,divId.length);
	var tempRls=document.getElementById(tempId);
	if (tempRls)
	
	 {  
		tempRls.value=tempRls.value+e.innerText;
	}
	//detailTemplateChange(tempRls);
}


//˫��ϸ��ѡ���ʱ��Ĵ�������
//�������?ϸ��ѡ���еĶ���
function dbClickHandly(e){
 
	//ɾ�����е�����ģ���div
	removeDiv("divtemp");

}

///˫���¼���ı���ʽ?�ı�ģ������������
//�������?ϸ��ѡ���еĶ���
function dbClickChangeCss(e) {

	if (e.className == "DHCPERowSelected") {
	   
		e.className = "clsRowSelected";
		setChildInputAbled(e,"R");
		e.onmouseover = function () {
			this.className = "clsRowSelected";
		};
		e.onmouseout = function () {
			this.className = "RowEven";
		};
	} else {   
	
		e.className = "DHCPERowSelected";
		setChildInputAbled(e,"W");
		e.onmouseover = function () {
			
		};
		e.onmouseout = function () {
			
		};
	}
}
///author:������
///createTiame:2009-02-27
////����table��id���ø�table����tr������ƶ��¼���������
//�������?table ��id

function setTrMouseByTable(obj) {

	var obj = document.getElementById(obj);
	var objChild = obj.childNodes;
	
	for (var i = 0; i < objChild.length; i++) {
		if (objChild[i].nodeName == "TR") {
			setMounceHandly(objChild[i]);
		}
		var grandChild = objChild[i].childNodes;
		for (var j = 0; j < grandChild.length; j++) {
			if (grandChild[j].nodeName == "TR") {
				setMounceHandly(grandChild[j]);
			}
		}
	}
}

///author:������
///createTiame:2009-02-27
////����table��id���ø�table����tr��˫���¼��Ĵ�������
//�������?table ��id
function setTrDbcByTable(tableId) {
	var obj = document.getElementById(tableId);
	var objChild = obj.childNodes;
	
	for (var i = 0; i < objChild.length; i++) {
		var grandChild = objChild[i].childNodes;

		for (var j = 0; j < grandChild.length; j++) {
			if (grandChild[j].nodeName == "TR") {

				setDbHandly(grandChild[j]);
			}
		}
	}
}
///author:������
///createTiame:2009-02-27
//��ȡ����Դ�ĵ�ǰtable�е�����
function getSelectRow(e){
	var eSrc = window.event.srcElement;
	//�еĶ���	
	var rowObj = getRow(eSrc);
	//����
	var selectRow = rowObj.rowIndex;

	return selectRow;
}
///author:������
///createTiame:2009-02-27
//��ȡϸ���rowid?PAADM��rowid?������rowid����Ϊһ���Ը��ַ�������
//�������?ϸ������һ������?
//����ֵ?ϸ���rowid^PAADM��rowid^������rowid
function getReadyForSelection(e) {
	///��֪��Ӧ���ж���parentElement,ֻ����ʵ�����
	var TName=window.event.srcElement.parentElement.parentElement.parentElement.parentElement.Name
	var TblArr=document.getElementsByName('tDHCPEResultItemEdit');
	for (var i=0; i<TblArr.length; i++)	{
		if (TblArr[i].Name==TName)	{
			var obj=TblArr[i]
		}
	}
	var selectRow=getSelectRow(e)
	var RowObj=obj.rows[selectRow];
	vobj=RowObj;
	for (k=0; k<RowObj.all.length; k++)	{
		var ItemObj=RowObj.all[k];
		if (ItemObj.id=='ItemIDz'+selectRow) {ItemID=ItemObj.value};
		if (ItemObj.id=='OEORIRowIdz'+selectRow) {OEORIRowId=ItemObj.value};
	}
	
	var EpisodeID = document.getElementById("EpisodeID");
	if (EpisodeID) {
		EpisodeID = EpisodeID.value;
	}
	vItemID=ItemID
       vOEORIRowId=OEORIRowId

	return ItemID +"^"+EpisodeID +"^"+OEORIRowId
}

//ȥ���ַ��������еĿո�
//�������?�ַ���
//����ֵ?û�пո���ַ���
function Trim(obj)
{    
	var strs=obj.split(" ");
	var resultStr="";
	for (var i=0;i<strs.length ; i++)
	{
		resultStr=resultStr+strs[i];
	}
	return resultStr;
	
}


///author:������
///createTiame:2009-02-27
//����ϸ��Ľ��?ȥ����ϸ��ѡ��ı�����ɫ?����ģ������������?��������ѡ��������
//�������?ϸ�������ַ���?table��id
//��������?
function setTrByResult(selectResult,tableId){

	var obj = document.getElementById(tableId);
	var objChild = obj.childNodes;
	for (var i = 0; i < objChild.length; i++) {
		var grandChild = objChild[i].childNodes;
		
		for (var j = 0; j < grandChild.length; j++) {
			if (grandChild[j].nodeName == "TR") {
				
				var flag=0
				var tds=grandChild[j].childNodes;
				for (var k = 0; k < tds.length; k++) {
					if (tds[k].nodeName == "TD") {
						var results=selectResult.split(";");
						for (var m=0;m< results.length;m++ )
						{	
						   
						    results[m].split("(")[0]
							if (tds[k].value==results[m].split("(")[0])   //add by zl
							{
								flag=1;
								continue;
							}
						}
					}
				}
				
				var isChecked=document.getElementById("isChecked"+(j+1));
	
				if(flag==1){
					//���Ϊ1ʱ?��ʶ���б�ѡ��?���ø��е���ʽ
					grandChild[j].className="DHCPERowSelected";
					//���������Ϊ����
					setChildInputAbled(grandChild[j],"W");
					grandChild[j].onmouseover = function () {
			
					};
					grandChild[j].onmouseout = function () {
					};
					isChecked.checked="checked"
				}else{
					setChildInputAbled(grandChild[j],"W");
					// ûѡ��,���ø�������ƶ�����������
					setMounceHandly(grandChild[j]);
					isChecked.checked="";
				}
				
			}
		}
	}
}
///author:������
///createTiame:2009-02-27
//ϸ��ѡ�������ģ��Ĵ�������?����һ��ģ��div?����ʼ��
//�������?ϸ��ѡ������������Ķ���
function detailTemplateOnclik(e) {
	
	var ODRowid=e.id;
	var temIns=document.getElementById("temIns");
	if(temIns){
			temIns=temIns.value;
	}
	var templateStr=cspRunServerMethod(temIns,ODRowid);
	removeDiv("divtemp");
	var myDiv="divtemp"+ODRowid;
			
	if(templateStr==""||templateStr==null){
		return false;
	}else{
		
		var myTable="table"+ODRowid;
		var oDiv = document.getElementById(myDiv);
		if (TempDivFlag==1) {
			TempDivFlag=0;
			removeDiv("divtemp");
		} else {
			TempDivFlag=1
			removeDiv("divtemp");
			createDiv(myDiv);
			var innerTr=createTrByTemps(templateStr);
			setODSTempDiv(myDiv,myTable,innerTr);
			showDiv(e,myDiv);
			setTrMouseByTable(myTable);
		}
	}
}
///author:������
///createTiame:2009-02-27
//ϸ��ѡ�������������ݸı��Ĵ�������?������
//�������?ϸ��ѡ������������Ķ���
function detailTemplateChange(e){
	//ͨ��input ������td ����
	var currTd= e.parentNode;
	//td ����ĸ��׶���Ϊtr����
	var crrrTr=currTd.parentNode;
	//������
	//ReultUpdate(crrrTr);
	
}
///author:������
///createTiame:2009-02-27
//�����Լ����� �ڵ�ĵ�һ��div��id
//�������?����һ������
function getParentDiv(e) {
	var divId=""
	if(e.parentNode.nodeName=="DIV"){
			
			divId= e.parentNode.getAttribute("id");
	}else{
	
			divId=getParentDiv(e.parentNode);
	}

	return divId;
}
///author:������
///createTiame:2009-02-27
//�����Լ����ڵ�ĵ�һ��tr��tr����
//�������?����һ������
//
function getParentTr(e) {
	var trId=""
	if(e.parentNode.nodeName=="TR"){
			
			trId= e.parentNode
	}else{
	
			trId=getParentTr(e.parentNode);
	}

	return trId;
}
///author:������
///createTiame:2009-02-27
//����tr�����е�����ڵ��Ϊinput?name Ϊ?detailTemplate?+j�Ķ��������
//�������?e,һ��tr�Ķ���?type,�������Ƿ���õı�ʶ?w��ʶ����?r��ʶ������
function setChildInputAbled(e,type) {
  
	var currRow=e.id;

	if (currRow.substr(currRow.length-2,1)>=0&&currRow.substr(currRow.length-2,1)<10)
	{
		currRow=currRow.substr(currRow.length-2,2);
	}else{
		currRow=currRow.substr(currRow.length-1,1);
	}
	var childs=e.childNodes
	for (var i=0;i<childs.length ;i++ )
	{	if(childs[i]){
		var grandChilds=childs[i].childNodes;
		for (var j=0;j<grandChilds.length ;j++)
		{
			if(grandChilds[j]){
			if (grandChilds[j].nodeName=="INPUT"&&grandChilds[j].name==("detailTemplate"+currRow))
			{	
				
				
				if(true){
		
				grandChilds[j].onclick=function(){
							detailTemplateOnclik(this);
				}
				grandChilds[j].onchange=function(){
							detailTemplateChange(this);
				}
				grandChilds[j].readOnly="";
				}else{
					detailTemplateOnclik(this);
					grandChilds[j].readOnly="true";
					grandChilds[j].onclick=function(){
						
					}
				}

			}
			}
		}
	}
	}

}

///author:������
///createTiame:2009-02-27
///����div ��id������div?�������Ϊ��?�������е�div?�������Ϊdiv��DIV?����idΪdiv��ͷ��div
// �������?div ��id
function displayDiv(divId) {
	if (divId == "" || divId == null || divId == "undefind") {
		var divs = document.getElementsByTagName("div");

		for (var i = 0; i < divs.length; i++) {
			if (divs[i]) {
				divs[i].style.display = "none";
			}
		}
	}
	if (divId == "div"||divId=="DIV") {
		var divs = document.getElementsByTagName("div");
		for (var i = 0; i < divs.length; i++) {
			if(divs[i].id.substring(0,3)=="div"){
					divs[i].style.display = "none";
			}
		}
	}
	var oDiv = document.getElementById(divId);

	if (oDiv) {
		oDiv.style.display = "none";
	}
}
///author:������
///createTiame:2009-02-27
//��ʾdiv����ǰ�Ĵ���Ԫ�ص�����
function showDiv(obj, divId) {
        // ����Ԫ��
   
	var el = obj;
        // ���Ԫ�ص���ƫ����
	var left = obj.offsetLeft;
        // ���Ԫ�صĶ���ƫ����
	var top = obj.offsetTop;

        // ѭ�����Ԫ�صĸ����ؼ�?�ۼ���Ͷ���ƫ����
	while (obj = obj.offsetParent) {
		left += obj.offsetLeft;
		top += obj.offsetTop;
	}

        // ���ò�����겢��ʾ
        //document.all.divShow.style.pixelLeft = left;
	document.getElementById(divId).style.position = "absolute";
	document.getElementById(divId).style.pixelLeft = left;
        // ��Ķ��˾���ΪԪ�صĶ��˾������Ԫ�صĸ�
	document.getElementById(divId).style.pixelTop = top + el.offsetHeight;
	document.getElementById(divId).style.display = "";
}
///author:������
///createTiame:2009-02-27
//����ϸ��ѡ�������ģ���div���ڲ����
function setODSTempDiv(divId,tableId,innerTr) {
	
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+">"+innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="20";
	}
}
///author:������
///createTiame:2009-02-27
//����ϸ��ѡ���div���ڲ����
function setDiv(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	
	if (oDiv) {
		var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none; '></TH>" + "</TH>" + "<TH  id=2  NOWRAP width='80px' background-color='red'> <input   type='button'     name='SaveButton'   value='�ر�'     onclick='SaveData();'   >" + "</TH>" +"<TH id=3  NOWRAP width='80px'>\u6807\u51c6" + "</TH>" + "<TH id=4  NOWRAP>\u662f\u5426\u6b63\u5e38\u503c" + "</TH>" + "<TH id=6  NOWRAP>\u63cf\u8ff0" + "</TH>" + "</THEAD>" +innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="19";
	}
}
function SaveData()
{
	var eSrc=window.event.srcElement;
	var divId=getParentDiv(eSrc)	
	///�õ�ϸ�����
	var objResultId=divId.substring(3,divId.length);
	var tableId="table"+objResultId;
	if (objResultId.substr(objResultId.length-2,1)<10&&objResultId.substr(objResultId.length-2,1)>=0)
	{	 
		var ODRow=objResultId.substr(objResultId.length-2,2);
	}else{
	var ODRow=objResultId.substr(objResultId.length-1,1);
	}
	
	///�õ�����˵�ADM
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	
	//�õ��������ݵķ���
	var Ins=document.getElementById('UpdateBox');
   	if (Ins) {var encmeth=Ins.value} 
    	else {var encmeth=''}
   	
	
	//RltStr?Ҫ���ֵĽ��?��Ϊ����������̨�ദ��
	var RltStr="";
	var RtnStr="";
	var tempDesc="";
	var Strs="",OneStr=""
	//tempDesc ������ʶ��ֵ?��������?ֵΪ1?������ʱΪ3
	var normalFlag="1" ;
	var obj=document.getElementsByName("TSelect");

	for (var i=0;i<obj.length;i++)
	{
		if (obj[i].checked)
		{
			var ODobj=document.getElementById("odsTr"+(i+1));
			var CellTextVal=document.getElementById('odSelection'+(i+1));
			var CellTempDesc=document.getElementById('detailTemplate'+(i+1));
           
            if (CellTempDesc.value!=""&&CellTempDesc.value!=null)
            {
	           var OneStr=CellTextVal.value+"("+CellTempDesc.value+")"
            }
            else {OneStr=CellTextVal.value}
            
            if (Strs==""){Strs=OneStr}
            else {Strs=Strs+";"+OneStr}
            
		
			if (RltStr==""){
			
				RltStr=CellTextVal.value+''+CellTempDesc.value
				RtnStr=CellTextVal.innerText;
				var ShowStr=CellTextVal.innerText
		
	
			}
			else{
				RltStr=RltStr+";"+CellTextVal.innerText+''+CellTempDesc.value+''
				RtnStr=RtnStr+";"+CellTextVal.innerText;
			
			}
	
			if (CellTempDesc.value!=""&&CellTempDesc.value!=null)
			{   
			        if(tempDesc==""){tempDesc=CellTempDesc.value}
			        else {	tempDesc=tempDesc+";"+CellTempDesc.value}
				
			}
		
		}
	}

	var obj=document.getElementById("ExamDesc");
	if (obj){ var OldStr=obj.value
	    if (OldStr!=""){obj.value=OldStr+","+RltStr;}
	    else {obj.value=RltStr;}
		
	}
	displayDiv(divId);
	removeDiv("divtemp");

}
///author:������
///createTiame:2009-02-27
///ɾ��div
function removeDiv(divId){
	
	var divs = document.getElementsByTagName("div");
	if (divId == "divtemp" || divId=="DIVTEMP"){
	
	for (var i = 0; i < divs.length; i++) {
			
			if(divs[i].id.substring(0,7)=="divtemp"){
				
					var p=divs[i].parentNode;
					p.removeChild(divs[i]);
			}
		}
	}else if (divId == "div" ||divId=="DIV"){
		removeDiv("divtemp");
		for (var j = 0; j <divs.length; j++) {
		
			if(divs[j].id.substring(0,3)=="div"){
					var p=divs[j].parentNode;
					p.removeChild(divs[j]);
			}
		}
	}else{
		var oDiv = document.getElementById(divId);
		if (oDiv) {
			oDiv.removeNode(true);
		}
	}
}
///author:������
///createTiame:2009-02-27
//��̬�Ĵ������div
function createDiv(divId) {
	var oDiv = document.createElement("div");
	oDiv.setAttribute("id", divId);
	oDiv.style.border = "1px solid black";
	oDiv.style.width = "250px";
	oDiv.style.index = "0";
	oDiv.style.height = "10px";
	oDiv.style.backgroundColor = "#E1E1E1";
	oDiv.style.display = "none";
	document.body.appendChild(oDiv);
}
///author:������
///createTiame:2009-02-27
//����ģ���������������?

function createTrByTemps(templateStr){

	var innerTr=""
	trs=templateStr.split("^");
	for (var i=0;i<trs.length ;i++ )
	{
		if (trs[i]!=""&&trs!=null)
		{
			innerTr=innerTr+"<tr ><td onclick='ODSTempOnClick(this);' width='250' value="+trs[i]+">"+trs[i]+"</td></tr>"
		}
	}
		
	return innerTr;

}

///author:������
///createTiame:2009-02-27
//����ϸ��ѡ��Ľ����������?
//�������?ϸ�������ַ���
function createTrByODS(result){
	var innerTr=""

	var rows=result.split(";");
	
	for(var i=0;i<rows.length;i++){
		if (rows[i]=="")
		{
			continue;
		}
		cols=rows[i].split("^");
		//alert(cols[3])
		if(cols[3]==1){
			var check="checked='checked'";
		}else{
			var check="";
		}
		cols[5]=Trim(cols[5]);
		var HadTemplate=cols[4]
		var NutureText=""
		if (HadTemplate==1) NutureText="<font color=red><b>  -&gt</font>"
		var trId="odsTr"+i
		var tdId="odSelection"+i;
		var isNatureValue="isNatureValue"+i;
		var templateId="detailTemplate"+i;
		var isChecked="isChecked"+i
		//alert(isChecked)
		//ϸ���д���С�ں���ʾ������  wrz
		var valueStr=cols[2].replace("<","&lt")
		var valueStr=valueStr.replace(">","&gt")
		innerTr=innerTr+"<tr id="+trId+"><td><input type='checkbox' onclick='CheckedHandly(this);'  id="+isChecked+" name=TSelect"+"></input></td><td id="+tdId+"  value="+valueStr+">"+cols[2]+"</td><td><input id="+isNatureValue+" type='checkbox' disabled='true' "+check+">"+NutureText+"</input></td><td><input id="+cols[0]+"  name="+templateId+"  type='text' size='40'   value="+cols[5]+"  ></input></td></tr>"


	}
	return innerTr;

}
///author:������
///createTiame:2009-02-27
//����ѡ��Ĵ����¼�
function CheckedHandly(e){
	
   

	var currRowObj=getParentTr(e);
	var currRow=getSelectRow(e)
	var curNature=0;
	var currNatureValue=document.getElementById('isNatureValue'+currRow)
	if (currRowObj)
	{

	removeDiv("divtemp");
	dbClickChangeCss(currRowObj);
	}
	
	
	var divId= getParentDiv(e);
	var objResultId=divId.substring(3,divId.length);
	var tableId="table"+objResultId;

    var TblObj=document.getElementById(tableId);
    for(var j=1;j<TblObj.rows.length;j++){
	var RowObj=TblObj.rows[j];
		var CellSelect=document.getElementById(RowObj.id);
		var Checked=document.getElementById('isChecked'+j)
		var CellNatureValue=document.getElementById('isNatureValue'+j)
		var Nature=0
		
		if (currNatureValue.checked==true){curNature=1;}
		if (CellNatureValue.checked==true){	Nature=1;}
		if (curNature!=1)
			{if (Nature==1)
			{Checked.checked=false}
			}
		if (curNature==1)
			{if (Nature==0)
			{Checked.checked=false}
			}
	}
  
}
///author:������
///createTiame:2009-02-27
//�ı�ѡ��������,
//����Ĳ���?ϸ��ѡ����ж���
function changeChecked(e){
	var currRow=getSelectRow(e);
	var checkedObj=document.getElementById("isChecked"+currRow);
	if (checkedObj)
	{	
		
		if (checkedObj.checked=="")
		{
	
			checkedObj.checked="checked"
		}else{
	
			checkedObj.checked="";
		}
	}
}

function detailStandard() {
	//selectRow Ϊ��ǰϸ�������


	var ButtId=window.event.srcElement.name;
	var selectResult=""
	gLastRow=ButtId.split("^")[1];
	var OEORDItemID=ButtId.split("^")[0];
    var UpdateMothod=document.getElementById("GetOrderDetailID");
	var encmeth="";
	if (UpdateMothod) encmeth=UpdateMothod.value;
	var OrderDetail=cspRunServerMethod(encmeth,OEORDItemID);
	var ins = document.getElementById("GetODStandard");
	if(ins){
		ins=ins.value;
	}
	var EpisodeID=""
     EpisodeID = document.getElementById("EpisodeID");
	if (EpisodeID) {
		EpisodeID = EpisodeID.value;
	}
	var Str=OrderDetail+"^"+EpisodeID+"^"+OEORDItemID
	var ODStandard=cspRunServerMethod(ins,Str);
	
	var innerTr=createTrByODS(ODStandard);
	var myDiv = "div"   // //+ e.id;
	var tableId="table" // +e.id
	var oDiv = document.getElementById(myDiv);
	if (oDiv) {
			
				removeDiv("div");
	} else {
		 removeDiv("div");
		
		createDiv(myDiv);
		setDiv(myDiv,tableId,innerTr);
      
		setTrMouseByTable(tableId);
		 
		setTrDbcByTable(tableId);
	    var ExamDesc = document.getElementById("ExamDesc")
		showDiv(ExamDesc,myDiv);   //  ??
			
		setTrByResult(selectResult,tableId);
		
	}
	
}