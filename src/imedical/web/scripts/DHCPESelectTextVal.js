var TempDivFlag=0
//used
//����ƶ��¼���������
function setMounceHandly(e) {
	e.className = "RowEven";
	e.onmouseover = function () {
		this.className = "clsRowSelected";
	};
	e.onmouseout = function () {
		this.className = "RowEven";
	};
}
//used
//����˫���¼��Ĵ�������
function setDbHandly(e) {
	
	e.ondblclick = function () {
		dbClickHandly(this);
	};
}
//used
//�û�˫��ϸ��ѡ��ģ���ʱ��Ĵ�������
function ODSTempDblClick(e){
	var divId=getParentDiv(e);
	var tempId=divId.substring(7,divId.length);
	var tempRls=document.getElementById(tempId);
	if (tempRls)
	{
		tempRls.value=tempRls.value+e.innerText;
	}
	//detailTemplateChange(tempRls);
}
//used
//˫��ϸ��ѡ���ʱ��Ĵ�������
//�������:ϸ��ѡ���еĶ���
function dbClickHandly(e){
	//ɾ�����е�����ģ���div
	removeDiv("divtemp");
	//�޸�css��ʽ
	dbClickChangeCss(e);
	//�޸�ѡ����ѡ������
	changeChecked(e);
	//������
	//ReultUpdate(e);
}
//used
//˫���¼���ı���ʽ �ı�ģ������������
//�������:ϸ��ѡ���еĶ���
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
//used
//����table��id����table����tr������ƶ��¼���������
//�������:table��id
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
//used
//����table��id����table����tr��˫���¼��Ĵ�������
//�������:table��id
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
//used
//��ȡ����Դ�ĵ�ǰtable�е�����
function getSelectRow(e){
	
	var eSrc = window.event.srcElement;
	
	//�еĶ���	
	var rowObj = getRow(eSrc);

	//ѡ������
	var selectRow = rowObj.rowIndex;
  
	return selectRow;
}

//used
//ȥ���ַ��������еĿո�
//�������:�ַ���
//����ֵ:û�пո���ַ���
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
//used
//ϸ�����Ĵ������� ����һ��ϸ��ѡ���div ����ʼ�����е�ֵ
//�������:ϸ�����Ķ���
function detailStandard(e) {
	
	//selectRow Ϊ��ǰϸ�������
	var selectRow=e.selectedIndex;
	if (selectRow==-1) return;
	var selectItemID=window.event.srcElement.value.split("^")[0];
	var selectResult=window.event.srcElement.options[selectRow].text.split("->")[1];
    if (selectResult==null) selectResult="";
    var Ins=document.getElementById('resultClick');
	if (Ins) {var Ins=Ins.value; } else {var Ins=''; };
	var selection=tkMakeServerCall("web.DHCPE.ResultEdit","GetItemResultStr2",selectItemID);
	
    
    
	var othertype=selection.split("^")[1];
	if (othertype=="T") {
		var innerTr=createTrByODST(selection);
		var myDiv = "div" + e.id;
		var tableId="table" + e.id;
		var oDiv = document.getElementById(myDiv);
		if (oDiv) { removeDiv("div"); } 
		else 
		{
			removeDiv("div");
			createDiv(myDiv);
			setDivT(myDiv,tableId,innerTr);
			setTrMouseByTable(tableId);
			setTrDbcByTable(tableId);
			showDiv(e,myDiv);
			setTrByResult(selectResult,tableId);
		}
	}
	else if ((othertype=="N")||(othertype=="C")) {
		var innerTr=createTrByODSN(selection);
		var myDiv = "div" + e.id;
		var tableId="table" + e.id;
		var oDiv = document.getElementById(myDiv);
		if (oDiv) { removeDiv("div"); } 
		else 
		{
			removeDiv("div");
			createDiv(myDiv);
			setDivN(myDiv,tableId,innerTr);
			setTrMouseByTable(tableId);
			setTrDbcByTable(tableId);
			showDiv(e,myDiv);
			setTrByResult(selectResult,tableId);
		}
	}
	else if (othertype=="R") {
		var innerTr=createTrByODSR(selection);
		var myDiv = "div" + e.id;
		var tableId="table" + e.id;
		var oDiv = document.getElementById(myDiv);
		if (oDiv) { removeDiv("div"); } 
		else 
		{
			removeDiv("div");
			createDiv(myDiv);
			setDivR(myDiv,tableId,innerTr);
			setTrMouseByTable(tableId);
			setTrDbcByTable(tableId);
			showDiv(e,myDiv);
			setTrByResult(selectResult,tableId);
		}
	}
	else {
		var innerTr=createTrByODS(selection);
		var myDiv = "div" + e.id;
		var tableId="table" + e.id;
		var oDiv = document.getElementById(myDiv);
		if (oDiv) { removeDiv("div"); } 
		else 
		{
			removeDiv("div");
			createDiv(myDiv);
			setDiv(myDiv,tableId,innerTr);
			setTrMouseByTable(tableId);
			setTrDbcByTable(tableId);
			showDiv(e,myDiv);
			setTrByResult(selectResult,tableId);
		}
	}
	
}
//used
//����ϸ��Ľ��ȥ����ϸ��ѡ��ı�����ɫ ����ģ������������ ��������ѡ��������
//�������:ϸ�������ַ��� table��id
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
						for (var m=0;m<results.length;m++)
						{
							var lresults=results[m].split(",")[0];
							var rresults=results[m].split(",")[1];
							if (rresults==null) rresults="";
							if (tds[k].value==lresults)
							{
								var TemplateDetail=document.getElementById("detailTemplate"+(j+1));
				                TemplateDetail.value=rresults;
								flag=1;
								continue;
							}
						}
					}
				}
				
				var isChecked=document.getElementById("isChecked"+(j+1));
				
				if(flag==1){
					//���Ϊ1ʱ ��ʶ���б�ѡ�� ���ø��е���ʽ
					grandChild[j].className="DHCPERowSelected";
					//���������Ϊ����
					setChildInputAbled(grandChild[j],"W");
					grandChild[j].onmouseover = function () {
			
					};
					grandChild[j].onmouseout = function () {
					};
					isChecked.checked="checked";
					
				}else{
					setChildInputAbled(grandChild[j],"W");
					// ûѡ��,���ø�������ƶ�����������
					setMounceHandly(grandChild[j]);
					if(isChecked) isChecked.checked="";
				}
				
			}
		}
	}
}
//used
//ϸ��ѡ�������ģ��Ĵ������� ����һ��ģ��div ����ʼ��
//�������:ϸ��ѡ������������Ķ���
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
//used
//ϸ��ѡ�������������ݸı��Ĵ������� ������
//�������:ϸ��ѡ������������Ķ���
function detailTemplateChange(e){
	//ͨ��input ������td ����
	var currTd= e.parentNode;
	//td ����ĸ��׶���Ϊtr����
	var crrrTr=currTd.parentNode;
	//������
	//ReultUpdate(crrrTr);
	
}
//used
//�����Լ����׽ڵ�ĵ�һ��div��id
//�������:����һ������
function getParentDiv(e) {
	var divId=""
	if(e.parentNode.nodeName=="DIV"){
			
			divId= e.parentNode.getAttribute("id");
	}else{
	
			divId=getParentDiv(e.parentNode);
	}

	return divId;
}
//used
//�����Լ����ڵ�ĵ�һ��tr��tr����
//�������:����һ������
function getParentTr(e) {
	var trId=""
	if(e.parentNode.nodeName=="TR"){
			
			trId= e.parentNode
	}else{
	
			trId=getParentTr(e.parentNode);
	}

	return trId;
}
//used
//����tr�����е�����ڵ��Ϊinput name Ϊ detailTemplate +j�Ķ��������
//�������:e,һ��tr�Ķ��� type,�������Ƿ���õı�ʶ w��ʶ���� r��ʶ������
function setChildInputAbled(e,type) {

	var currRow=e.id;
	if (currRow.substr(currRow.length-2,1)>=0&&currRow.substr(currRow.length-2,1)<10)
	{
		currRow=currRow.substr(currRow.length-2,2);
	}else{
		currRow=currRow.substr(currRow.length-1,1);
	}
	var childs=e.childNodes;
	for (var i=0;i<childs.length;i++)
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
//used
//����div ��id������div �������Ϊ�� �������е�div �������Ϊdiv��DIV ����idΪdiv��ͷ��div
//�������:div ��id
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
//used
//��ʾdiv����ǰ�Ĵ���Ԫ�ص�����
function showDiv(obj, divId) {
        // ����Ԫ��
   
	var el = obj;
        // ���Ԫ�ص���ƫ����
	var left = obj.offsetLeft;
        // ���Ԫ�صĶ���ƫ����
	var top = obj.offsetTop;

        // ѭ�����Ԫ�صĸ����ؼ� �ۼ���Ͷ���ƫ����
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
//used
//����ϸ��ѡ�������ģ���div���ڲ����
function setODSTempDiv(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+">"+innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="20";
	}
}
//used
//����ϸ��ѡ���div���ڲ����
function setDiv(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none;'></TH>" + "<TH  id=2  NOWRAP width='80px'> <input   type='button'     name='SaveButton'   value='����'     onclick='SaveData();'   >" + "</TH>" +"<TH id=3  NOWRAP width='80px'>\u6807\u51c6" + "</TH>" + "<TH id=4  NOWRAP>\u662f\u5426\u6b63\u5e38\u503c" + "</TH>" + "<TH id=5  NOWRAP>\u63cf\u8ff0" + "</TH>" + "</THEAD>" +innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="19";
	}
}

function setDivT(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none;'></TH>" + "<TH  id=2  NOWRAP width='80px'> <input   type='button'     name='SaveButton'   value='����'     onclick='SaveDataT();'   >" + "</TH>" + "<TH id=3  NOWRAP>�ٴ����"  + "</TH>" + "<TH id=4  NOWRAP>�������" + "</TH>" + "<TH id=5  NOWRAP>������" + "</TH>" + "</THEAD>" +innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="19";
	}
}
function setDivR(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none;'></TH>" + "<TH  id=2  NOWRAP width='80px'> <input   type='button'     name='SaveButton'   value='����'     onclick='SaveDataR();'   >" + "</TH>" + "<TH id=3  NOWRAP width='120px'>��������"  + "</TH>" + "</THEAD>" +innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="19";
	}
}
function setDivN(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none;'></TH>" + "<TH  id=2  NOWRAP width='80px'> <input   type='button'     name='SaveButton'   value='����'     onclick='SaveDataN();'   >" + "</TH>" + "<TH id=3  NOWRAP>��λ" + "</TH>" + "<TH id=4  NOWRAP>��Сֵ" + "</TH>" + "<TH id=5  NOWRAP>���ֵ" + "</TH>" + "</THEAD>" +innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="19";
	}
}
//used
//ѡ��
function SaveData()
{
	var eSrc=window.event.srcElement;
	var divId=getParentDiv(eSrc);
	var RltStr="",RltIdStr="";
	var obj=document.getElementsByName("TSelect");
	for (var i=0;i<obj.length;i++)
	{
		if (obj[i].checked)
		{
			var CellTextVal=document.getElementById('odSelection'+(i+1));
			var CellTempDesc=document.getElementById('detailTemplate'+(i+1));
			//var CellTextValID=CellTempDesc.id;
			CellTextValID=CellTempDesc.value.split("^")[1];
			
			if (CellTextValID==""){
				RltIdStr=CellTextValID;
			}
			else{
				RltIdStr=RltIdStr+"!"+CellTextValID;
			}
			if (RltStr==""){
				RltStr=CellTextVal.innerText;
			}
			else{
				RltStr=RltStr+";"+CellTextVal.innerText;
			}
			/*if (CellTempDesc.value!=""&&CellTempDesc.value!=null){
				RltIdStr=RltIdStr+"@"+CellTempDesc.value;
			}
			if (CellTempDesc.value!=""&&CellTempDesc.value!=null){
				RltStr=RltStr+","+CellTempDesc.value;
			}
			*/
			if (CellTempDesc.value.split("^")[0]!=""&&CellTempDesc.value!=null){
				RltIdStr=RltIdStr+"@"+CellTempDesc.value.split("^")[0];
			}
			if (CellTempDesc.value.split("^")[0]!=""&&CellTempDesc.value!=null){
				RltStr=RltStr+","+CellTempDesc.value.split("^")[0];
			}
		}
	}
	
	var obj=document.getElementById('StandardsList');
	if (obj) {
			var selectedIndex=obj.selectedIndex;
			var ItemID=obj.options[obj.selectedIndex].value.split("^")[0];
			var ItemName=obj.options[obj.selectedIndex].text.split("->")[0];
			if(RltStr=="") {obj.options[obj.selectedIndex].text=ItemName;obj.options[obj.selectedIndex].value=ItemID;}
			else{obj.options[obj.selectedIndex].value=ItemID+"^"+"S"+"^"+RltIdStr;obj.options[obj.selectedIndex].text=ItemName+"->"+RltStr;}
	}
	
	
	displayDiv(divId);
	removeDiv("divtemp");
}
//˵��
function SaveDataT()
{
	var eSrc=window.event.srcElement;
	var divId=getParentDiv(eSrc);
	var CellODDesc=document.getElementById('odSelection');
	var CellTempDesc1=document.getElementById('detailTemplate1');
	if (CellTempDesc1) { desc1=CellTempDesc1.value;}
	var CellTempDesc2=document.getElementById('detailTemplate2');
	if (CellTempDesc2) { desc2=CellTempDesc2.value;}
	var CellTempDesc3=document.getElementById('detailTemplate3');
	if (CellTempDesc3) { desc3=CellTempDesc3.value;}
	
	var RltStr=desc1+"@"+desc2+"@"+desc3;
    
	var obj=document.getElementById('StandardsList');
	if (obj) {
			var selectedIndex=obj.selectedIndex;
			var ItemID=obj.options[obj.selectedIndex].value.split("^")[0];
			var ItemName=obj.options[obj.selectedIndex].text.split("->")[0].split("-")[0];
			if (desc1=="") {obj.options[obj.selectedIndex].value=ItemID;obj.options[obj.selectedIndex].text=ItemName;}
			else{
			 obj.options[obj.selectedIndex].value=ItemID+"^"+"T"+"^"+RltStr;
			 var TDesc2=",�������:"+desc2;var TDesc3=",������:"+desc3;
			 if (desc2=="") TDesc2="";if (desc3=="") TDesc3="";
			 obj.options[obj.selectedIndex].text=ItemName+"->"+"�ٴ����:"+desc1+TDesc2+TDesc3;}
	}
	
	displayDiv(divId);
	removeDiv("divtemp");
}
//�ܼ����
function SaveDataR()
{
	var eSrc=window.event.srcElement;
	var divId=getParentDiv(eSrc);
	var CellODDesc=document.getElementById('odSelection');
	var CellTempDesc=document.getElementById('detailTemplate');
	if (CellTempDesc) { desc=CellTempDesc.value;}

	var RltStr=desc;
    
	var obj=document.getElementById('StandardsList');
	if (obj) {
			var selectedIndex=obj.selectedIndex;
			
			var ItemID=obj.options[obj.selectedIndex].value.split("^")[0];
			var ItemName=obj.options[obj.selectedIndex].text.split("->")[0].split("-")[0];
			if (desc=="") {obj.options[obj.selectedIndex].value=ItemID;obj.options[obj.selectedIndex].text=ItemName;}
			else {obj.options[obj.selectedIndex].value=ItemID+"^"+"R"+"^"+RltStr;
			      obj.options[obj.selectedIndex].text=ItemName+"->"+"��������:"+RltStr;}

	}
	
	displayDiv(divId);
	removeDiv("divtemp");
}
//��ֵ����
function SaveDataN()
{
	var min="",max="";
	var eSrc=window.event.srcElement;
	var divId=getParentDiv(eSrc);
	var CellODDesc=document.getElementById('odSelection');
	var ODMin=document.getElementById('min');
	if (ODMin) { min=ODMin.value;}
	var ODMax=document.getElementById('max');
	if (ODMax) { max=ODMax.value;}
	var ODUnit=document.getElementById('odUnit');
	if (ODUnit) { unit=ODUnit.innerText;}
	
	var RltStr=min+"*"+max;

	var obj=document.getElementById('StandardsList');
	if (obj) {
			var selectedIndex=obj.selectedIndex;
			var ItemID=obj.options[obj.selectedIndex].value.split("^")[0];
			var ItemName=obj.options[obj.selectedIndex].text.split("->")[0];
			obj.options[obj.selectedIndex].value=ItemID+"^"+"N"+"^"+RltStr;
			if ((min!="")&&(max=="")) {obj.options[obj.selectedIndex].text=ItemName+"->"+"����"+min+unit;}
			if ((min=="")&&(max!="")) {obj.options[obj.selectedIndex].text=ItemName+"->"+"С��"+max+unit;}
			if ((min!="")&&(max!="")) {obj.options[obj.selectedIndex].text=ItemName+"->"+"����"+min+unit+"С��"+max+unit;}
			if ((min=="")&&(max=="")) {obj.options[obj.selectedIndex].text=ItemName;obj.options[obj.selectedIndex].value=ItemID;}
	}
	
	
	displayDiv(divId);
	removeDiv("divtemp");
}
//used
//ɾ��div
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
//used
//��̬�Ĵ���һ��div
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
//used
//����ģ��������������� 
function createTrByTemps(templateStr){
	var innerTr=""
	trs=templateStr.split("^");
	for (var i=0;i<trs.length ;i++ )
	{
		if (trs!=""&&trs!=null)
		{
			innerTr=innerTr+"<tr ><td ondblclick='ODSTempDblClick(this);' width='250' value="+trs[i]+">"+trs[i]+"</td></tr>"
		}
	}
		
	return innerTr;

}
//used
//����ϸ��ѡ��Ľ���������� 
//�������:ϸ�������ַ���
function createTrByODS(result){
	var innerTr=""

	var rows=result.split(";");
	
	for(var i=0;i<rows.length;i++){
		if (rows[i]=="")
		{
			continue;
		}
		cols=rows[i].split("^");
		if(cols[3]==1){
			var check="checked='checked'";
		}else{
			var check="";
		}
		cols[5]=Trim(cols[5]);
		var trId="odsTr"+i;
		var tdId="odSelection"+i;
		var isNatureValue="isNatureValue"+i;
		var templateId="detailTemplate"+i;
		var isChecked="isChecked"+i;
		var valueStr=cols[2].replace("<","&lt")
		var valueStr=valueStr.replace(">","&gt")
		//innerTr=innerTr+"<tr id="+trId+"><td><input type='checkbox' onclick='CheckedHandly(this);'  id="+isChecked+" name=TSelect"+"></input></td><td id="+tdId+"  value="+valueStr+">"+cols[2]+"</td><td><input id="+isNatureValue+" type='checkbox' disabled='true' "+check+"></input></td><td><input id="+cols[0]+"  name="+templateId+"  type='text' size='40' value="+cols[5]+"></input></td></tr>"
	    innerTr=innerTr+"<tr id="+trId+"><td><input type='checkbox' onclick='CheckedHandly(this);'  id="+isChecked+" name=TSelect"+"></input></td><td id="+tdId+"  value="+valueStr+">"+cols[2]+"</td><td><input id="+isNatureValue+" type='checkbox' disabled='true' "+check+"></input></td><td><input id="+templateId+"  name="+templateId+"  type='text' size='40' value="+cols[5]+"^"+cols[0]+"></input></td></tr>"
	}
	return innerTr;

}

function createTrByODST(result){
	var innerTr=""
    var cols=result.split("^");
	var obj=document.getElementById('StandardsList');
	if (obj) {
		var selectedIndex=obj.selectedIndex;
		var RlTText=obj.options[obj.selectedIndex].value.split("^")[2];
	}
	if (RlTText==null) {RlTText="";}
	var RlTText1=RlTText.split("@")[0];
	if (RlTText1==null) {RlTText1="";}
	var RlTText2=RlTText.split("@")[1];
	if (RlTText2==null) {RlTText2="";}
	var RlTText3=RlTText.split("@")[2];
	if (RlTText3==null) {RlTText3="";}
	var valueStr=cols[2].replace("<","&lt");
	var valueStr=valueStr.replace(">","&gt");
	//innerTr=innerTr+"<tr id='odsTr'><td id='odSelection' height='50px' value="+valueStr+">"+cols[2]+"</td><td><textarea name='detailTemplate1' rows='3' cols='30'>"+RlTText1+"</textarea></td><td><textarea name='detailTemplate2' rows='3' cols='30'>"+RlTText2+"</textarea></td><td><textarea name='detailTemplate3' rows='3' cols='30'>"+RlTText3+"</textarea></td></tr>"
	innerTr=innerTr+"<tr id='odsTr'><td id='odSelection' height='50px' value="+valueStr+">"+cols[2]+"</td><td><textarea name='detailTemplate1' id='detailTemplate1' rows='3' cols='30'>"+RlTText1+"</textarea></td><td><textarea name='detailTemplate2' id='detailTemplate2' rows='3' cols='30'>"+RlTText2+"</textarea></td><td><textarea name='detailTemplate3' id='detailTemplate3' rows='3' cols='30'>"+RlTText3+"</textarea></td></tr>"
	
	return innerTr;

}
function createTrByODSR(result){
	var innerTr=""
    var cols=result.split("^");
	var obj=document.getElementById('StandardsList');
	if (obj) {
		var selectedIndex=obj.selectedIndex;
		var RlTText=obj.options[obj.selectedIndex].value.split("^")[2];
	}
	if (RlTText==null) {RlTText="";}
	var valueStr=cols[2].replace("<","&lt");
	var valueStr=valueStr.replace(">","&gt");
	//innerTr=innerTr+"<tr id='odsTr'><td id='odSelection' height='50px' value="+valueStr+">"+cols[2]+"</td><td><textarea name='detailTemplate' rows='3' cols='30'>"+RlTText+"</textarea></td></tr>"
	innerTr=innerTr+"<tr id='odsTr'><td id='odSelection' height='50px' value="+valueStr+">"+cols[2]+"</td><td><textarea name='detailTemplate' id='detailTemplate' rows='3' cols='30'>"+RlTText+"</textarea></td></tr>"
	
	return innerTr;

}
function createTrByODSN(result){
	var innerTr=""
    var cols=result.split("^");
	var obj=document.getElementById('StandardsList');
	if (obj) {
		var selectedIndex=obj.selectedIndex;
		var RlTRange=obj.options[obj.selectedIndex].value.split("^")[2];
	}
	if (RlTRange==null) {RlTRange="";}
	var Min=RlTRange.split("*")[0];
	if (Min==null) {Min="";}
	var Max=RlTRange.split("*")[1];
	if (Max==null) {Max="";}
	var valueStr=cols[2].replace("<","&lt");
	var valueStr=valueStr.replace(">","&gt");
	//innerTr=innerTr+"<tr id='odsTr'><td id='odSelection' value="+valueStr+">"+cols[2]+"</td><td id='odUnit'>"+cols[3]+"</td><td><input name='min'  type='text' size='20' value="+Min+"></input></td><td><input name='max'  type='text' size='20' value="+Max+"></input></td></tr>"
	innerTr=innerTr+"<tr id='odsTr'><td id='odSelection' value="+valueStr+">"+cols[2]+"</td><td id='odUnit'>"+cols[3]+"</td><td><input name='min'  id='min' type='text' size='20' value="+Min+"></input></td><td><input name='max'  id='max' type='text' size='20' value="+Max+"></input></td></tr>"
	
	return innerTr;

}
//used
//����ѡ��Ĵ����¼�
function CheckedHandly(e){

	var currRowObj=getParentTr(e);
	if (currRowObj)
	{
	removeDiv("divtemp");
	dbClickChangeCss(currRowObj);
	//setChildInputAbled(currRowObj,"W");
	//ReultUpdate(currRowObj);
	}
}
//used
//�ı�ѡ��������
//����Ĳ���:ϸ��ѡ����ж���
function changeChecked(e){
	
	var currRow=getSelectRow(e);
	var checkedObj=document.getElementById("isChecked"+currRow);
	if (checkedObj)
	{	
		
		if (checkedObj.checked=="")
		{
			checkedObj.checked="checked";
		}else{
	
			checkedObj.checked="";
		}
	}
}