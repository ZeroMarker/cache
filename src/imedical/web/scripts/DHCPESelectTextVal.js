var TempDivFlag=0
//used
//鼠标移动事件触发函数
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
//设置双击事件的触发函数
function setDbHandly(e) {
	
	e.ondblclick = function () {
		dbClickHandly(this);
	};
}
//used
//用户双击细项选择模板的时候的触发函数
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
//双击细项选择的时候的触发函数
//传入参数:细项选择行的对象
function dbClickHandly(e){
	//删除所有的描述模板的div
	removeDiv("divtemp");
	//修改css样式
	dbClickChangeCss(e);
	//修改选择框的选择属性
	changeChecked(e);
	//保存结果
	//ReultUpdate(e);
}
//used
//双击事件后改变样式 改变模板输入框的属性
//传入参数:细项选择行的对象
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
//根据table的id设置table的子tr的鼠标移动事件触发函数
//传入参数:table的id
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
//根据table的id设置table的子tr的双击事件的触发函数
//传入参数:table的id
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
//获取触发源的当前table中的行数
function getSelectRow(e){
	
	var eSrc = window.event.srcElement;
	
	//行的对象	
	var rowObj = getRow(eSrc);

	//选中行数
	var selectRow = rowObj.rowIndex;
  
	return selectRow;
}

//used
//去除字符串中所有的空格
//传入参数:字符串
//返回值:没有空格的字符串
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
//细项结果的触发函数 创建一个细项选择的div 并初始化其中的值
//传入参数:细项结果的对象
function detailStandard(e) {
	
	//selectRow 为当前细项的行数
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
//根据细项的结果去设置细项选择的背景颜色 描述模板输入框的属性 保存项中选择框的属性
//传入参数:细项结果的字符串 table的id
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
					//标记为1时 标识该行被选中 设置该行的样式
					grandChild[j].className="DHCPERowSelected";
					//设置输入框为可用
					setChildInputAbled(grandChild[j],"W");
					grandChild[j].onmouseover = function () {
			
					};
					grandChild[j].onmouseout = function () {
					};
					isChecked.checked="checked";
					
				}else{
					setChildInputAbled(grandChild[j],"W");
					// 没选中,设置该行鼠标移动到触发函数
					setMounceHandly(grandChild[j]);
					if(isChecked) isChecked.checked="";
				}
				
			}
		}
	}
}
//used
//细项选择的描述模板的触发函数 创建一个模板div 并初始化
//传入参数:细项选择的描述输入框的对象
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
//细项选择中描述的内容改变后的触发函数 保存结果
//传入参数:细项选择的描述输入框的对象
function detailTemplateChange(e){
	//通过input 对象获得td 对象
	var currTd= e.parentNode;
	//td 对象的父亲对象为tr对象
	var crrrTr=currTd.parentNode;
	//保存结果
	//ReultUpdate(crrrTr);
	
}
//used
//返回自己父亲节点的第一个div的id
//传入参数:任意一个对象
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
//返回自己父节点的第一个tr的tr对象
//传入参数:任意一个对象
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
//设置tr对象中的子孙节点的为input name 为 detailTemplate +j的对象的属性
//传入参数:e,一个tr的对象 type,输入框的是否可用的标识 w标识可用 r标识不可用
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
//根据div 的id来隐藏div 如果传入为空 隐藏所有的div 如果参数为div或DIV 隐藏id为div开头的div
//传入参数:div 的id
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
//显示div到当前的触发元素的下面
function showDiv(obj, divId) {
        // 保存元素
   
	var el = obj;
        // 获得元素的左偏移量
	var left = obj.offsetLeft;
        // 获得元素的顶端偏移量
	var top = obj.offsetTop;

        // 循环获得元素的父级控件 累加左和顶端偏移量
	while (obj = obj.offsetParent) {
		left += obj.offsetLeft;
		top += obj.offsetTop;
	}

        // 设置层的坐标并显示
        //document.all.divShow.style.pixelLeft = left;
	document.getElementById(divId).style.position = "absolute";
	document.getElementById(divId).style.pixelLeft = left;
        // 层的顶端距离为元素的顶端距离加上元素的高
	document.getElementById(divId).style.pixelTop = top + el.offsetHeight;
	document.getElementById(divId).style.display = "";
}
//used
//设置细项选择的描述模板的div的内部表格
function setODSTempDiv(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+">"+innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="20";
	}
}
//used
//设置细项选择的div的内部表格
function setDiv(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none;'></TH>" + "<TH  id=2  NOWRAP width='80px'> <input   type='button'     name='SaveButton'   value='保存'     onclick='SaveData();'   >" + "</TH>" +"<TH id=3  NOWRAP width='80px'>\u6807\u51c6" + "</TH>" + "<TH id=4  NOWRAP>\u662f\u5426\u6b63\u5e38\u503c" + "</TH>" + "<TH id=5  NOWRAP>\u63cf\u8ff0" + "</TH>" + "</THEAD>" +innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="19";
	}
}

function setDivT(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none;'></TH>" + "<TH  id=2  NOWRAP width='80px'> <input   type='button'     name='SaveButton'   value='保存'     onclick='SaveDataT();'   >" + "</TH>" + "<TH id=3  NOWRAP>临床诊断"  + "</TH>" + "<TH id=4  NOWRAP>检查所见" + "</TH>" + "<TH id=5  NOWRAP>诊断意见" + "</TH>" + "</THEAD>" +innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="19";
	}
}
function setDivR(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none;'></TH>" + "<TH  id=2  NOWRAP width='80px'> <input   type='button'     name='SaveButton'   value='保存'     onclick='SaveDataR();'   >" + "</TH>" + "<TH id=3  NOWRAP width='120px'>疾病名称"  + "</TH>" + "</THEAD>" +innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="19";
	}
}
function setDivN(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none;'></TH>" + "<TH  id=2  NOWRAP width='80px'> <input   type='button'     name='SaveButton'   value='保存'     onclick='SaveDataN();'   >" + "</TH>" + "<TH id=3  NOWRAP>单位" + "</TH>" + "<TH id=4  NOWRAP>最小值" + "</TH>" + "<TH id=5  NOWRAP>最大值" + "</TH>" + "</THEAD>" +innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="19";
	}
}
//used
//选择
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
//说明
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
			 var TDesc2=",检查所见:"+desc2;var TDesc3=",诊断意见:"+desc3;
			 if (desc2=="") TDesc2="";if (desc3=="") TDesc3="";
			 obj.options[obj.selectedIndex].text=ItemName+"->"+"临床诊断:"+desc1+TDesc2+TDesc3;}
	}
	
	displayDiv(divId);
	removeDiv("divtemp");
}
//总检结论
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
			      obj.options[obj.selectedIndex].text=ItemName+"->"+"疾病名称:"+RltStr;}

	}
	
	displayDiv(divId);
	removeDiv("divtemp");
}
//数值计算
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
			if ((min!="")&&(max=="")) {obj.options[obj.selectedIndex].text=ItemName+"->"+"大于"+min+unit;}
			if ((min=="")&&(max!="")) {obj.options[obj.selectedIndex].text=ItemName+"->"+"小于"+max+unit;}
			if ((min!="")&&(max!="")) {obj.options[obj.selectedIndex].text=ItemName+"->"+"大于"+min+unit+"小于"+max+unit;}
			if ((min=="")&&(max=="")) {obj.options[obj.selectedIndex].text=ItemName;obj.options[obj.selectedIndex].value=ItemID;}
	}
	
	
	displayDiv(divId);
	removeDiv("divtemp");
}
//used
//删除div
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
//动态的创建一个div
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
//根据模板的内容设置行数 
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
//根据细项选择的结果设置行数 
//传入参数:细项结果的字符串
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
//保存选框的触发事件
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
//改变选择框的属性
//传入的参数:细项选择的行对象
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