//DHCPERisOrderDetailCommon.js
///author:周莉
//用于体检ris项目手动录入
/////鼠标移动事件触发函数
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
///author:汪福建
///createTiame:2009-02-27
///设置双击细项选择事件的触发函数
function setDbHandly(e) {
	e.ondblclick = function ()
	 {  
		dbClickHandly(this);
	};
}
///author:汪福建
///createTiame:2009-02-27
//用户双击细项选择模板的时候的触发函数
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


//双击细项选择的时候的触发函数
//传入参数?细项选择行的对项
function dbClickHandly(e){
 
	//删除所有的描述模板的div
	removeDiv("divtemp");

}

///双击事件后改变样式?改变模板输入框的属性
//传入参数?细项选择行的对项
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
///author:汪福建
///createTiame:2009-02-27
////根据table的id设置改table的子tr的鼠标移动事件触发函数
//传入参数?table 的id

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

///author:汪福建
///createTiame:2009-02-27
////根据table的id设置改table的子tr的双击事件的触发函数
//传入参数?table 的id
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
///author:汪福建
///createTiame:2009-02-27
//获取触发源的当前table中的行数
function getSelectRow(e){
	var eSrc = window.event.srcElement;
	//行的对象	
	var rowObj = getRow(eSrc);
	//行数
	var selectRow = rowObj.rowIndex;

	return selectRow;
}
///author:汪福建
///createTiame:2009-02-27
//获取细项的rowid?PAADM的rowid?遗嘱的rowid并做为一个以个字符串返回
//传入参数?细项结果的一个对象?
//返回值?细项的rowid^PAADM的rowid^遗嘱的rowid
function getReadyForSelection(e) {
	///不知道应该有多少parentElement,只能是实验出来
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

//去除字符串中所有的空格
//传入参数?字符串
//返回值?没有空格的字符串
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


///author:汪福建
///createTiame:2009-02-27
//根据细项的结果?去设置细项选择的背景颜色?描述模板输入框的属性?保存项中选择框的属性
//传入参数?细项结果的字符串?table的id
//传出参数?
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
					//标记为1时?标识该行被选中?设置该行的样式
					grandChild[j].className="DHCPERowSelected";
					//设置输入框为可用
					setChildInputAbled(grandChild[j],"W");
					grandChild[j].onmouseover = function () {
			
					};
					grandChild[j].onmouseout = function () {
					};
					isChecked.checked="checked"
				}else{
					setChildInputAbled(grandChild[j],"W");
					// 没选中,设置该行鼠标移动到触发函数
					setMounceHandly(grandChild[j]);
					isChecked.checked="";
				}
				
			}
		}
	}
}
///author:汪福建
///createTiame:2009-02-27
//细项选择的描述模板的触发函数?创建一个模板div?并初始化
//传入参数?细项选择的描述输入框的对象
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
///author:汪福建
///createTiame:2009-02-27
//细项选择中描述的内容改变后的触发函数?保存结果
//传入参数?细项选择的描述输入框的对象
function detailTemplateChange(e){
	//通过input 对象获得td 对象
	var currTd= e.parentNode;
	//td 对象的父亲对象为tr对象
	var crrrTr=currTd.parentNode;
	//保存结果
	//ReultUpdate(crrrTr);
	
}
///author:汪福建
///createTiame:2009-02-27
//返回自己父亲 节点的第一个div的id
//传入参数?任意一个对象
function getParentDiv(e) {
	var divId=""
	if(e.parentNode.nodeName=="DIV"){
			
			divId= e.parentNode.getAttribute("id");
	}else{
	
			divId=getParentDiv(e.parentNode);
	}

	return divId;
}
///author:汪福建
///createTiame:2009-02-27
//返回自己父节点的第一个tr的tr对象
//传入参数?任意一个对象
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
///author:汪福建
///createTiame:2009-02-27
//设置tr对象中的子孙节点的为input?name 为?detailTemplate?+j的对象的属性
//传入参数?e,一个tr的对象?type,输入框的是否可用的标识?w标识可用?r标识不可用
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

///author:汪福建
///createTiame:2009-02-27
///根据div 的id来隐藏div?如果传入为空?隐藏所有的div?如果参数为div或DIV?隐藏id为div开头的div
// 传入参数?div 的id
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
///author:汪福建
///createTiame:2009-02-27
//显示div到当前的触发元素的下面
function showDiv(obj, divId) {
        // 保存元素
   
	var el = obj;
        // 获得元素的左偏移量
	var left = obj.offsetLeft;
        // 获得元素的顶端偏移量
	var top = obj.offsetTop;

        // 循环获得元素的父级控件?累加左和顶端偏移量
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
///author:汪福建
///createTiame:2009-02-27
//设置细项选择的描述模板的div的内部表格
function setODSTempDiv(divId,tableId,innerTr) {
	
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = "<table id="+tableId+">"+innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="20";
	}
}
///author:汪福建
///createTiame:2009-02-27
//设置细项选择的div的内部表格
function setDiv(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	
	if (oDiv) {
		var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none; '></TH>" + "</TH>" + "<TH  id=2  NOWRAP width='80px' background-color='red'> <input   type='button'     name='SaveButton'   value='关闭'     onclick='SaveData();'   >" + "</TH>" +"<TH id=3  NOWRAP width='80px'>\u6807\u51c6" + "</TH>" + "<TH id=4  NOWRAP>\u662f\u5426\u6b63\u5e38\u503c" + "</TH>" + "<TH id=6  NOWRAP>\u63cf\u8ff0" + "</TH>" + "</THEAD>" +innerTr+"</table>";
		oDiv.innerHTML = innerhtml;
		oDiv.style.index="19";
	}
}
function SaveData()
{
	var eSrc=window.event.srcElement;
	var divId=getParentDiv(eSrc)	
	///得到细项的行
	var objResultId=divId.substring(3,divId.length);
	var tableId="table"+objResultId;
	if (objResultId.substr(objResultId.length-2,1)<10&&objResultId.substr(objResultId.length-2,1)>=0)
	{	 
		var ODRow=objResultId.substr(objResultId.length-2,2);
	}else{
	var ODRow=objResultId.substr(objResultId.length-1,1);
	}
	
	///得到体检人的ADM
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	
	//得到保存数据的方法
	var Ins=document.getElementById('UpdateBox');
   	if (Ins) {var encmeth=Ins.value} 
    	else {var encmeth=''}
   	
	
	//RltStr?要保持的结果?作为参数传到后台类处理
	var RltStr="";
	var RtnStr="";
	var tempDesc="";
	var Strs="",OneStr=""
	//tempDesc 正常标识的值?当正常是?值为1?不正常时为3
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
///author:汪福建
///createTiame:2009-02-27
///删除div
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
///author:汪福建
///createTiame:2009-02-27
//动态的创建议个div
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
///author:汪福建
///createTiame:2009-02-27
//根据模板的内容设置行数?

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

///author:汪福建
///createTiame:2009-02-27
//根据细项选择的结果设置行数?
//传入参数?细项结果的字符串
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
		//细项中大于小于号显示有问题  wrz
		var valueStr=cols[2].replace("<","&lt")
		var valueStr=valueStr.replace(">","&gt")
		innerTr=innerTr+"<tr id="+trId+"><td><input type='checkbox' onclick='CheckedHandly(this);'  id="+isChecked+" name=TSelect"+"></input></td><td id="+tdId+"  value="+valueStr+">"+cols[2]+"</td><td><input id="+isNatureValue+" type='checkbox' disabled='true' "+check+">"+NutureText+"</input></td><td><input id="+cols[0]+"  name="+templateId+"  type='text' size='40'   value="+cols[5]+"  ></input></td></tr>"


	}
	return innerTr;

}
///author:汪福建
///createTiame:2009-02-27
//保存选框的触发事件
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
///author:汪福建
///createTiame:2009-02-27
//改变选择框的属性,
//传入的参数?细项选择的行对象
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
	//selectRow 为当前细项的行数


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