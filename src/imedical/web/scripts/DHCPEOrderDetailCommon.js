//DHCPEOrderDetailCommon.js
///author:汪福建
///createTiame:2009-02-27
/////鼠标移动事件触发函数
var vItemID=""
var vOEORIRowId=""
var vobj=""
var TempDivFlag=0
var EDDivFlag=0
var CurEDRow=0
function setMounceHandly(e) {
	
	e.className = "RowEven";
	e.onmouseover = function () {
		//this.className = "clsRowSelected";
	};
	e.onmouseout = function () {
		//this.className = "RowEven";
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
///author:汪福建
///createTiame:2009-02-27
//执行细项结果保存操作
//传入的参数: e:细项选择的行对象
function ReultUpdate(e){
	//为更新准备数据
	//获得细项的行数
	var divId= getParentDiv(e);
	var objResultId=divId.substring(3,divId.length);
	var tableId="table"+objResultId;
	if (objResultId.substr(objResultId.length-2,1)<10&&objResultId.substr(objResultId.length-2,1)>=0)
	{	
		var ODRow=objResultId.substr(objResultId.length-2,2);
	}else{
	var ODRow=objResultId.substr(objResultId.length-1,1);
	}
	//通过细项的行数得到?细项的rowid?遗嘱的rowid?PaADM的rowid
	
	var ItemID= document.getElementById("ItemIDz"+ODRow);
	if (ItemID)
	{	
		ItemID=ItemID.value;
	}
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	var OEORIRowId=""
  	var obj=document.getElementById("OEORIRowIdItem");
    	if (obj){
		OEORIRowId=obj.value;
	}
	//RltStr?要保持的结果?作为参数传到后台类处理
	var RltStr="";
	//RtnStr 细项结果属性的值
	var RtnStr=""	;
		///tempDesc 细项描述属性的值
	var tempDesc="" ;
	/////tempDesc 正常标识的值?当正常是?值为1?不正常时为3
	var normalFlag="1" ;
	
	var TblObj=document.getElementById(tableId);
	for(var j=1;j<TblObj.rows.length;j++){
		var RowObj=TblObj.rows[j];
		var CellSelect;
		var CellTextVal;
		var Nature;
		var CellSelect=document.getElementById(RowObj.id);

		var CellTextVal=document.getElementById('odSelection'+j)
		var CellTempDesc=document.getElementById('detailTemplate'+j)
		var CellNatureValue=document.getElementById('isNatureValue'+j)
		if (CellSelect.className=="DHCPERowSelected") {
			var Nature=0;
			if (CellNatureValue.checked==true){
				Nature=1;
			}else{
				normalFlag="3"
				if (CellTextVal.style.color=="red") {normalFlag="2"}  //高危
			}
			if (RltStr==""){
			
				RltStr=CellTextVal.value+'\001'+CellTempDesc.value+'\001'+Nature
				RtnStr=CellTextVal.innerText;
				
			}
			else{
				RltStr=RltStr+"^"+CellTextVal.innerText+'\001'+CellTempDesc.value+'\001'+Nature
				RtnStr=RtnStr+";"+CellTextVal.innerText;
			
			}
			if (CellTempDesc.value!=""&&CellTempDesc.value!=null)
			{
					tempDesc=tempDesc+";"+CellTempDesc.value
			}
		} 	
	}
	
	var Ins=document.getElementById('UpdateBox');
   	if (Ins) {var encmeth=Ins.value} 
	else {var encmeth=''}
   	//保存数据
   	var flag=cspRunServerMethod(encmeth,ItemID,RltStr,EpisodeID,OEORIRowId);

	if ('0'==flag){
		//结果
	    var ODRObj = document.getElementById(objResultId);
		ODRObj.value=RtnStr
		//描述
		var descObj=document.getElementById("TTemplateDescz"+ODRow);
		tempDesc=tempDesc.substr(1,tempDesc.length)
		descObj.innerText=tempDesc;


		//正常标识
		var normalFlagIns=document.getElementById("normalFlagIns");
			normalFlagIns=normalFlagIns.value
		var normalFlagImg=cspRunServerMethod(normalFlagIns,normalFlag);
		if (normalFlagImg!=""&&normalFlagImg!=" "&&normalFlagImg!=null)
		{
			var normalFlagObj=document.getElementById("TNormalFlagz"+ODRow);
			
			normalFlagObj.childNodes[0].src="../images/"+normalFlagImg;
		}
		var ItemObj=document.getElementById('ItemDescz'+ODRow);
		if (ItemObj){
			if (normalFlag=="3"){ //异常
				ItemObj.style.color='red';
			}else if (normalFlag=="1"){ //正常
				ItemObj.style.color='';
			}else{  //2高危
				ItemObj.style.color='yellow';
			}
		}
		
	}else{
		alert("Update error.ErrNo="+flag)
    } 	
   
 
			
}
///author:汪福建
///createTiame:2009-02-27
//双击细项选择的时候的触发函数
//传入参数?细项选择行的对项
function dbClickHandly(e){

	//删除所有的描述Ｄ０宓膁iv
	removeDiv("divtemp");
	//修改css样式
	//dbClickChangeCss(e);
	//修改选择框的选择属性
	//changeChecked(e);
	//保存结果
	//ReultUpdate(e);
}
///author:汪福建
///createTiame:2009-02-27
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
////细项结果的触发函数?创建一个细项选择的div?并初始化其中的值
//传入参数:细项结果的对象

function detailStandard(e) {
	setCaret(e)
	//selectRow 为当前细项的行数
	var selectRow=getSelectRow(e);
	
	var selectResult=window.event.srcElement.value

	var strReadyForSelection=getReadyForSelection(e)
	var ins = document.getElementById("resultClick");
	if(ins){
		ins=ins.value;
	}
	//细项选择的结果?一个字串
	//alert(strReadyForSelection)
	var selection=cspRunServerMethod(ins,strReadyForSelection);
	if (selection=="") return false;
	var innerTr=createTrByODS(selection);
	var myDiv = "div" + e.id;
	var tableId="table"+e.id
	var oDiv = document.getElementById(myDiv);
	if (oDiv) {
				//removeDiv("divtemp");
				removeDiv("div");
	} else {
		//removeDiv("divtemp");
		 removeDiv("div");
		createDiv(myDiv);
		setDiv(myDiv,tableId,innerTr);

		setTrMouseByTable(tableId);
		setTrDbcByTable(tableId);
		showDiv(e, myDiv);
		setTrByResult(selectResult,tableId);
	}
	
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
								var Num=tds[k].id.split("odSelection")[1];
								var isChecked=document.getElementById("isChecked"+(Num));
								isChecked.checked="checked"
								continue;
							}
						}
					}
				}
				/*
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
				}*/
				
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
			//removeDiv("divtemp");
		} else {
			TempDivFlag=1;
			//removeDiv("divtemp");
			createDiv(myDiv);
			var innerTr=createTrByTemps(templateStr);
			innerTr="<table id="+myTable+">"+innerTr+"</table>";
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
function EDIdChange(e){
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
			if (grandChilds[j].nodeName=="INPUT"&&grandChilds[j].name==("EDId"+currRow))
			{	
				
				
				if(true){
		
				grandChilds[j].onclick=function(){
							EDIdOnclik(this);
				}
				grandChilds[j].onchange=function(){
							EDIdChange(this);
				}
				grandChilds[j].readOnly="";
				}else{
					EDIdOnclik(this);
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
	divObj=document.getElementById(divId);
	document.getElementById(divId).style.position = "absolute";
	if (divId.split("divItemSel").length>1){ //细项选择
		if (left-200>0){
			document.getElementById(divId).style.pixelLeft = left-200;
		}else{
			document.getElementById(divId).style.pixelLeft = left;
		}
	}else if (divId.split("divtemp").length>1){  //模板
		document.getElementById(divId).style.display = "";
		var divWdith=document.getElementById(divId).offsetWidth;
		document.getElementById(divId).style.display = "none";
		var bodyWidth=document.body.clientWidth
		if (left+divWdith>bodyWidth){
			left=left+(bodyWidth-divWdith-left)
		}
		document.getElementById(divId).style.pixelLeft = left;
		
	}else{ //建议
		document.getElementById(divId).style.pixelLeft = left;
	}
	// 层的顶端距离为元素的顶端距离加上元素的高
	document.getElementById(divId).style.pixelTop = top + el.offsetHeight;
	document.getElementById(divId).style.display = "";
	divHeight=document.getElementById(divId).offsetHeight;
	document.getElementById(divId).style.display = "none";
	bodyHeight=window.screen.availHeight-parent.BottomHeight;
	if ((divHeight + top + el.offsetHeight)>bodyHeight){
		if (top - divHeight>0){  //
			divTop=top - divHeight
		}else{//上面显示不下,就让下面有滚动条显示
			divTop=top + el.offsetHeight;
		}
	}else{
		divTop=top + el.offsetHeight;
	}
    document.getElementById(divId).style.pixelTop =divTop;
    document.getElementById(divId).style.display = "";
}
///author:汪福建
///createTiame:2009-02-27
//设置细项选择的描述模板的div的内部表格
function setODSTempDiv(divId,tableId,innerTr) {
	var oDiv = document.getElementById(divId);
	if (oDiv) {
		var innerhtml = innerTr //"<table id="+tableId+">"+innerTr+"</table>";
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
		//var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none; '></TH>" + "</TH>" + "<TH  id=2  NOWRAP width='10px' background-color='red'> <input   type='button'     name='SaveButton'   value='保存'     onclick='SaveData();'   >" + "</TH>" +"<TH id=3  NOWRAP width='80px'>\u6807\u51c6" + "</TH>" + "<TH id=4  NOWRAP>正常" + "</TH>" + "<TH id=6  NOWRAP>\u63cf\u8ff0" + "</TH>"
		//innerhtml = innerhtml+"<TH style='display:none; '></TH>" + "</TH>" + "<TH  id=2  style='display:none; ' NOWRAP width='35px' background-color='red'>选择</TH>" +"<TH id=3  NOWRAP width='80px'>\u6807\u51c6" + "</TH>" + "<TH id=4  NOWRAP>正常" + "</TH>" + "<TH id=6  NOWRAP>\u63cf\u8ff0" + "</TH>"
		
		
		var innerhtml = "<table id="+tableId+"><THEAD><TH style='display:none; '></TH>" + "</TH>" + "<TH  style='display:none; ' id=2  NOWRAP width='10px' background-color='red'> <input   type='button'     name='SaveButton'   value='保存'     onclick='SaveData();'   >" + "</TH>" +"<TH id=3  style='display:none; NOWRAP width='120px'>\u6807\u51c6" + "</TH>" + "<TH style='display:none; ' id=4  NOWRAP>正常" + "</TH>" + "<TH style='display:none; ' id=6  NOWRAP>\u63cf\u8ff0" + "</TH>"
		innerhtml = innerhtml+"<TH style='display:none; '></TH>" + "</TH>" + "<TH  id=2  style='display:none; ' NOWRAP width='35px' background-color='red'>选择</TH>" +"<TH id=3  style='display:none; NOWRAP width='120px'>\u6807\u51c6" + "</TH>" + "<TH style='display:none; ' id=4  NOWRAP>正常" + "</TH>" + "<TH style='display:none; ' id=6  NOWRAP>\u63cf\u8ff0" + "</TH>"
		var innerHTML="<table id="+tableId+">"
		
		innerhtml = innerhtml+innerTr+"</THEAD></table>";  //+ "<TH id=7  NOWRAP>建议" + "</TH>"
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
			var CellNatureValue=document.getElementById('isNatureValue'+(i+1));
           
            if (CellTempDesc.value!=""&&CellTempDesc.value!=null)
            {var OneStr=CellTextVal.value+"("+CellTempDesc.value+")"}
            else {OneStr=CellTextVal.value}
            if (Strs==""){Strs=OneStr}
            else {Strs=Strs+";"+OneStr}
            
			var Nature=0;
			if ((CellNatureValue)&&(CellNatureValue.checked==true)){
				Nature=1;
			}else{
				normalFlag="3"
				//alert(CellTextVal.value)
				if (CellTextVal.style.color=="red") {normalFlag="2"}  //高危
			}
			if (RltStr==""){
			
				RltStr=CellTextVal.value+'\001'+CellTempDesc.value+'\001'+Nature
				RtnStr=CellTextVal.innerText;
				var ShowStr=CellTextVal.innerText
		
	
			}
			else{
				RltStr=RltStr+"^"+CellTextVal.innerText+'\001'+CellTempDesc.value+'\001'+Nature
				RtnStr=RtnStr+";"+CellTextVal.innerText;
			
			}
	
			if (CellTempDesc.value!=""&&CellTempDesc.value!=null)
			{   
			        if(tempDesc==""){tempDesc=CellTempDesc.value}
			        else {	tempDesc=tempDesc+";"+CellTempDesc.value}
				
			}
		
		}
	}
	//保存数据
   	var flag=cspRunServerMethod(encmeth,vItemID,RltStr,EpisodeID,vOEORIRowId);
	if ('0'==flag) 
   	 {
		//正常标识
		var normalFlagIns=document.getElementById("normalFlagIns");
		normalFlagIns=normalFlagIns.value
		var normalFlagImg=cspRunServerMethod(normalFlagIns,normalFlag);

		for (k=0; k<vobj.all.length; k++)	{
			var ItemObj=vobj.all[k];
			if (ItemObj.id==objResultId) {ItemObj.value=Strs}
			if (ItemObj.id=='TTemplateDescz'+ODRow) {ItemObj.innerText=tempDesc}
			if (ItemObj.id=='ItemDescz'+ODRow) {
				if (normalFlag=="3"){ //异常
					ItemObj.style.color='red';
				}else if (normalFlag=="1"){ //正常
					ItemObj.style.color='';
				}else{  //2高危
					ItemObj.style.color='yellow';
				}
			}
			if (normalFlagImg!=""&&normalFlagImg!=" "&&normalFlagImg!=null)
			{   
				if (ItemObj.id=="TNormalFlagz"+ODRow) {ItemObj.childNodes[0].src="../images/"+normalFlagImg;};
			}
		}
		
	}
    	else{
		alert("Update error.ErrNo="+flag)
	} 
	
	displayDiv(divId);
	removeDiv("divtemp");
}
function EDIdOnclik(e) {
	
	var ODRowid=e.id;
	CurEDRow=e.parentNode.parentNode.rowIndex;
	var otherDesc=e.value;
	ODRowid=ODRowid.split("ED")[1];
	var OEORIRowId=""
  	var RLTID=ODRowid.split("^")[2];
	if (ODRowid.split("^").length>1){
		OEORIRowId=ODRowid.split("^")[1];
		ODRowid=ODRowid.split("^")[0];
	}else{
		var obj=document.getElementById("OEORIRowIdItem");
    		if (obj){
			OEORIRowId=obj.value;
		}
	}
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	var obj=document.getElementById("ChartID");
	var ChartID=""
	if (obj) ChartID=obj.value;
	var temIns=document.getElementById("GetEDInfo");
	if(temIns){
			temIns=temIns.value;
	}
	var templateStr=cspRunServerMethod(temIns,OEORIRowId,EpisodeID,ODRowid,ChartID,otherDesc);
	removeDiv("dived");
	var myDiv="dived"+ODRowid;
			
	if(templateStr==""||templateStr==null){
		return false;
	}else{
		var myTable="tableed"+ODRowid;
		var oDiv = document.getElementById(myDiv);
		if (EDDivFlag==1) {
			EDDivFlag=0;
			//removeDiv("dived");
		} else {
			EDDivFlag=1;
			//removeDiv("dived");
			createDiv(myDiv);
			var innerTr=createTrByEDs(templateStr);
			var innerTr = "<table name="+OEORIRowId+"^"+ODRowid+"^"+RLTID+" id="+myTable+"><THEAD><TH style='display:none; '></TH>" + "<TH  style='display:none;'  id=SaveED  NOWRAP width='20px' background-color='red'> <input  style='display:none;'   type='button'  id="+OEORIRowId+"^"+ODRowid+"^"+RLTID+"   name='SaveEDButton'   value='保存'     onclick='SaveEDData();'   >" + "</TH>" +"<TH  style='display:none;'  id=3  NOWRAP width='20px'>ID" + "</TH>" + "<TH id=6  NOWRAP width='80px'>诊断" + "</TH>" + "<TH id=4  NOWRAP width='180px'>建议" + "</TH>" + "<TH  style='display:none;'  id=7  NOWRAP>代码" + "</TH>"+"<TH style='display:none; '></TH>" + "<TH  style='display:none;'  id=SaveED  NOWRAP width='20px' background-color='red'> <input  style='display:none;'   type='button'  id="+OEORIRowId+"^"+ODRowid+"^"+RLTID+"   name='SaveEDButton'   value='保存'     onclick='SaveEDData();'   >" + "</TH>" +"<TH  style='display:none;'  id=3  NOWRAP width='20px'>ID" + "</TH>" + "<TH id=6  NOWRAP width='80px'>诊断" + "</TH>" + "<TH id=4  NOWRAP width='180px'>建议" + "</TH>" + "<TH  style='display:none;'  id=7  NOWRAP>代码" + "</TH>" + "</THEAD>" +innerTr+"</table>";
	
			setODSTempDiv(myDiv,myTable,innerTr);
			showDiv(e,myDiv);
			setTrMouseByTable(myTable);
		}
	}
}
function SaveEDData()
{
	var eSrc=window.event.srcElement;
	var divId=getParentDiv(eSrc)
	var OrdItemID=eSrc.id.split("^")[0];
	var ODID=eSrc.id.split("^")[1];
	var RLTID=eSrc.id.split("^")[2];
	var OtherDesc=""
	var OtherObj=document.getElementById("MK"+ODID+"^"+OrdItemID)
	if (OtherObj) OtherDesc=OtherObj.value
	///得到细项的行
	var objResultId=divId.substring(7,divId.length);
	var tableId="tableed"+objResultId;
	///得到体检人的ADM
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	var obj=document.getElementsByName("TEDSelect");
	for (var i=0;i<obj.length;i++)
	{
		if (obj[i].checked)
		{
			var IDObj=document.getElementById("ed"+(i));
			var EDID=IDObj.innerText;
			var ret=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","AutoInsertCondition",EDID,OrdItemID,ODID,OtherDesc,RLTID)
			try{
				if (parent.frames("diagnosis")){
					parent.frames("diagnosis").AddDiagnosis(EDID);
					
				}
			}catch(e){
				if (parent.opener){
					parent.opener.AddDiagnosis(EDID);
				}
				else{
					AddDiagnosis(EDID);
				}
			}
		}
	}
	displayDiv(divId);
	EDDivFlag=0;
	removeDiv("dived");
}

function SaveDiagnosis()
{   
    
	
	
}
///author:汪福建
///createTiame:2009-02-27
///删除div
function removeDiv(divId){
	
	var divs = document.getElementsByTagName("div");
	if (divId == "divtemp" || divId=="DIVTEMP"){
	//TempDivFlag=0;
	for (var i = 0; i < divs.length; i++) {
			
			if(divs[i].id.substring(0,7)=="divtemp"){
				
					var p=divs[i].parentNode;
					p.removeChild(divs[i]);
			}
		}
	}else if (divId == "dived" ||divId=="DIVED"){
		for (var j = 0; j <divs.length; j++) {
			if(divs[j].id.substring(0,3)=="div"){
					var p=divs[j].parentNode;
					p.removeChild(divs[j]);
			}
		}
	}else if (divId == "div" ||divId=="DIV"){
		TempDivFlag=0;
		EDDivFlag=0;
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
	//
	var DivWidth="250px";
	if (divId.substring(0,5)=="dived"){
		EDDivFlag=1;
		DivWidth="250px";
	}else if(divId.substring(0,7)=="divtemp"){
		TempDivFlag=1;
		DivWidth="210px";
	}
	
	var oDiv = document.createElement("div");
	oDiv.setAttribute("id", divId);
	oDiv.style.border = "1px solid black";
	oDiv.style.width = DivWidth;
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
			innerTr=innerTr+"<tr ><td onclick='ODSTempOnClick(this);' width='70' value="+trs[i]+">"+trs[i]+"</td>"
		}
		i=i+1
		if (i<trs.length){
			if (trs[i]!=""&&trs!=null) innerTr=innerTr+"<td onclick='ODSTempOnClick(this);' width='70' value="+trs[i]+">"+trs[i]+"</td>"
		}
		i=i+1
		if (i<trs.length){
			if (trs[i]!=""&&trs!=null) innerTr=innerTr+"<td onclick='ODSTempOnClick(this);' width='70' value="+trs[i]+">"+trs[i]+"</td>"
		}
		innerTr=innerTr+"</tr>"
	}
		
	return innerTr;

}
function createTrByEDs(templateStr){
	var innerTr=""
	var char_1=String.fromCharCode(1);
	trs=templateStr.split(char_1);
	for (var i=0;i<trs.length ;i++ )
	{
		cols=trs[i].split("^");
		var trId="edsTr"+i
		var tdId="edSelection"+i;
		var edId="ed"+i;
		var edDetail="edDetail"+i;
		var edDC="edDC"+i
		var edCode="edCode"+i;
		innerTr=innerTr+"<tr id="+trId+"><td  style='display:none;'><input type='checkbox' name=TEDSelect></td><td  style='display:none; ' id="+edId+">"+cols[0]+"</td><td style='color:green' ondblclick=EDDBLClick(); id='"+cols[0]+"'>"+cols[2]+"</td><td>"+cols[1]+"</td><td  style='display:none;'>"+cols[3]+"</td>"  //</tr>"
		i=i+1
		if (i<trs.length){
			cols=trs[i].split("^");
			var trId="edsTr"+i
			var tdId="edSelection"+i;
			var edId="ed"+i;
			var edDetail="edDetail"+i;
			var edDC="edDC"+i
			var edCode="edCode"+i;
			innerTr=innerTr+"<td  style='display:none;'><input type='checkbox' name=TEDSelect></td><td  style='display:none; ' id="+edId+">"+cols[0]+"</td><td style='color:green' ondblclick=EDDBLClick(); id='"+cols[0]+"'>"+cols[2]+"</td><td>"+cols[1]+"</td><td  style='display:none;'>"+cols[3]+"</td></tr>"
		}else{
			innerTr=innerTr+"</tr>"
		}
	}
	return innerTr;

}
function EDDBLClick()
{
	var eSrc=window.event.srcElement;
	var EDID=eSrc.id;
	//自动设置结果为建议名称
	var obj=document.getElementById("ItemSelz"+CurEDRow);
	var NutreObj=document.getElementById("NormalVz"+CurEDRow);
	if (obj&&NutreObj){
		if ((obj.value=="")||(obj.value==NutreObj.innerText))
		{
			obj.value=eSrc.innerText;
		}
	}
	//
	var ItemInfo=eSrc.parentNode.parentNode.parentNode.name;
	var Arr=ItemInfo.split("^");
	var OrdItemID=Arr[0];
	var ODID=Arr[1];
	var RLTID=Arr[2];
	///得到体检人的ADM
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	var OtherDesc=""
	var OtherObj=document.getElementById("MK"+ODID+"^"+OrdItemID)
	if (OtherObj) OtherDesc=OtherObj.value
	var ret=tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","AutoInsertCondition",EDID,OrdItemID,ODID,OtherDesc,RLTID)
	try{
		if (parent.frames("diagnosis")){
			parent.frames("diagnosis").AddDiagnosis(EDID);
		}
	}catch(e){
		if (parent.opener){
			parent.opener.AddDiagnosis(EDID);
		}
		else{
			AddDiagnosis(EDID);
		}
	}
	EDDivFlag=0;
	removeDiv("dived");
}
function DetailDBLClick(e)
{
	var eSrc=e;
	var i=(e.id).split("odSelection")[1]-1;
	var divId=getParentDiv(eSrc)
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
	

	var ODobj=document.getElementById("odsTr"+(i+1));
	var CellTextVal=document.getElementById('odSelection'+(i+1));
	var CellTempDesc=document.getElementById('detailTemplate'+(i+1));
	var CellNatureValue=document.getElementById('isNatureValue'+(i+1));


	if (CellTempDesc.value!=""&&CellTempDesc.value!=null){
		OneStr=CellTextVal.value+"("+CellTempDesc.value+")";
	}else {
		OneStr=CellTextVal.value;
	}
	if (Strs==""){
		Strs=OneStr;
	}else{
		Strs=Strs+";"+OneStr;
	}
	var Row=objResultId.split("ItemSelz")[1];
	var obj=document.getElementById(objResultId);
	var NatureDesc="";
	var NatureObj=document.getElementById("NormalVz"+Row);
	if (NatureObj) NatureDesc=NatureObj.innerText;
	if (Strs==NatureDesc){
		obj.value=Strs;
	}else if (obj.value==NatureDesc){
		obj.value="";
		insertAtCaret(obj, Strs);
	}else{
		insertAtCaret(obj, Strs);
	}
	//obj.focus();
	return false;
	
	
	var Nature=0;
	if ((CellNatureValue)&&(CellNatureValue.checked==true)){
		Nature=1;
	}else{
		normalFlag="3"
		if (CellTextVal.style.color=="red") {normalFlag="2"}  //高危
	}
	
	if (RltStr==""){
	
		RltStr=CellTextVal.value+'\001'+CellTempDesc.value+'\001'+Nature
		RtnStr=CellTextVal.innerText;
		var ShowStr=CellTextVal.innerText


	}else{
		RltStr=RltStr+"^"+CellTextVal.innerText+'\001'+CellTempDesc.value+'\001'+Nature
		RtnStr=RtnStr+";"+CellTextVal.innerText;
	
	}

	if (CellTempDesc.value!=""&&CellTempDesc.value!=null)
	{   
	        if(tempDesc==""){tempDesc=CellTempDesc.value}
	        else {	tempDesc=tempDesc+";"+CellTempDesc.value}
		
	}
	
	
	
	//保存数据
	var flag=cspRunServerMethod(encmeth,vItemID,RltStr,EpisodeID,vOEORIRowId);
	if ('0'==flag){
		
		
		//正常标识
		var normalFlagIns=document.getElementById("normalFlagIns");
		normalFlagIns=normalFlagIns.value
		var normalFlagImg=cspRunServerMethod(normalFlagIns,normalFlag);

		for (k=0; k<vobj.all.length; k++)	{
			var ItemObj=vobj.all[k];
			if (ItemObj.id==objResultId) {
				insertAtCaret(ItemObj, Strs)
				};//ItemObj.value=Strs
			if (ItemObj.id=='TTemplateDescz'+ODRow) {ItemObj.innerText=tempDesc};
			
			if (ItemObj.id=='ItemDescz'+ODRow) {
				if (normalFlag=="3"){ //异常
					ItemObj.style.color='red';
				}else if (normalFlag=="1"){ //正常
					ItemObj.style.color='';
				}else{  //2高危
					ItemObj.style.color='yellow';
				}
			}
			
			if (normalFlagImg!=""&&normalFlagImg!=" "&&normalFlagImg!=null)
			{   
				if (ItemObj.id=="TNormalFlagz"+ODRow) {ItemObj.childNodes[0].src="../images/"+normalFlagImg;};
			}
		}
		
		
		displayDiv(divId);
		removeDiv("div");
	}else{
		alert("Update error.ErrNo="+flag)
	} 
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
		var EDId="EDId"+i;
		//alert(isChecked)
		//细项中大于小于号显示有问题  wrz
		var valueStr=cols[2].replace("<","&lt")
		var valueStr=valueStr.replace(">","&gt")
		var valueStr=valueStr.replace(" ","&nbsp;")
		style="";
		if (cols[6]=="Y") style="color:red";
		innerTr=innerTr+"<tr id="+trId+"><td  style='display:none; '><input type='checkbox' onclick='CheckedHandly(this);'  id="+isChecked+" name=TSelect"+"></input></td><td width='120px' id="+tdId+" style='"+style+"' ondblclick=DetailDBLClick(this);  value="+valueStr+">"+cols[2]+"</td><td style='display:none; '><input id="+isNatureValue+" type='checkbox' disabled='true' "+check+">"+NutureText+"</input></td><td style='display:none; '><input id="+cols[0]+" onclick='detailTemplateOnclik(this);' style='width:80px' name="+templateId+" type='text' size='40' value="+cols[5]+"  ></input></td>" //</tr>"  //<td><input id=ED"+cols[0]+" readOnly='true' onclick='EDIdOnclik(this);' name="+EDId+"  type='text' size='20'   value="+""+"  ></input></td>
		i=i+1
		if (i<rows.length){
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
			var EDId="EDId"+i;
			//alert(isChecked)
			//细项中大于小于号显示有问题  wrz
			var valueStr=cols[2].replace("<","&lt")
			var valueStr=valueStr.replace(">","&gt")
			var valueStr=valueStr.replace(" ","&nbsp")
			//cols[2]=cols[6]+cols[2]
			style="";
			if (cols[6]=="Y") style="color:red";
			innerTr=innerTr+"<td  style='display:none; '><input type='checkbox' onclick='CheckedHandly(this);'  id="+isChecked+" name=TSelect"+"></input></td><td width='120px' id="+tdId+" style='"+style+"' ondblclick=DetailDBLClick(this); value="+valueStr+">"+cols[2]+"</td><td style='display:none; '><input id="+isNatureValue+" type='checkbox' disabled='true' "+check+">"+NutureText+"</input></td><td style='display:none; '><input id="+cols[0]+" onclick='detailTemplateOnclik(this);' style='width:80px' name="+templateId+" type='text' size='40' value="+cols[5]+"  ></input></td></tr>"  //<td><input id=ED"+cols[0]+" readOnly='true' onclick='EDIdOnclik(this);' name="+EDId+"  type='text' size='20'   value="+""+"  ></input></td>
		
		}else{
			innerTr=innerTr+"</tr>"
		}

	}
	return innerTr;

}
///author:汪福建
///createTiame:2009-02-27
//保存选框的触发事件
function CheckedHandly(e){
	
    var SetObj=e.parentNode.parentNode.parentNode.parentNode.id
    var currRowObj=getParentTr(e);
	var currRow=getSelectRow(e)
	var curNature=0;
	ID=e.id;
	var currRow=e.id.split("isChecked")[1];
	var currNatureValue=document.getElementById('isNatureValue'+currRow);
	if (currNatureValue.checked){curNature=1;}
	if (currRowObj)
	{
		removeDiv("divtemp");
		dbClickChangeCss(currRowObj);
	}
	var divId= getParentDiv(e);
	var objResultId=divId.substring(3,divId.length);
	var tableId="table"+objResultId;
	var TblObj=document.getElementById(tableId);
	//TblObj.rows.length
	var j=(TblObj.rows.length-1)*2
	for (i=1;i<=j;i++)
	{
		if (i==currRow) continue;		
		var Checked=document.getElementById('isChecked'+i);
		if (!Checked) break;
		var CellNatureValue=document.getElementById('isNatureValue'+i);
		var Nature=0
		if (CellNatureValue.checked){Nature=1;}
		if (curNature!=1){
			if (Nature==1) {Checked.checked=false};
		}else{
			if (Nature==0) {Checked.checked=false};
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
function nextfocusS(e)
{
	nextfocus(e);

	detailStandard(e);
} 
///Add wrz  医生录入结果界面上下箭头移动光标
function nextfocus(e) 
{
	var TName=window.event.srcElement.parentElement.parentElement.parentElement.parentElement.Name
	var TblArr=document.getElementsByName('tDHCPEResultItemEdit');

	var Row=0
	for (var i=0; i<TblArr.length; i++)	{
		if (TblArr[i].Name==TName)	{
			var obj=TblArr[i]
			Row=i+1
		}
	}
	var IsStr=TName.split("DHCPEResultItemEdit")[1];
	var UpdArr=document.getElementsByName('Update');
	for (var i=0; i<UpdArr.length; i++)	{
		var UpdName=UpdArr[i].Name;
		if (UpdName.split(IsStr).length>1) var UpdObj=UpdArr[i];
	}
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	var strArr=eSrc.id.split("z");
	var elementName=strArr[0]
	var i=strArr[1];
	if ((key==13)||(key==40))
	{
		i=+i+1
		elementName=elementName+"z"+i;
	}
	if (key==38)
	{
		i=+i-1
		elementName=elementName+"z"+i;
	}
	for (var j=1; j<obj.rows.length; j++)	{
		var RowObj=obj.rows[j];
		for (k=1; k<RowObj.all.length; k++)	{
			var ItemObj=RowObj.all[k];
			if (ItemObj.id==elementName) 
			{var nextObj=ItemObj;
			 nextObj.focus();};
		}
	}
	if ((i==0)||(i==j))
	{
		nextObj=UpdObj;
	}
	
}
function EDIdOnKey(eSrc)
{
	var key=websys_getKey(eSrc);
	if (key==13){
		EDIdOnclik(eSrc);
	}
}
function setCaret(textObj) {
	if (textObj.createTextRange) {
	    textObj.caretPos = document.selection.createRange().duplicate();
    }
}
function insertAtCaret(textObj, textFeildValue) {
    if (document.all) {
        if (textObj.createTextRange && textObj.caretPos) {
            var caretPos = textObj.caretPos;
            caretPos.text = caretPos.text.charAt(caretPos.text.length - 1) == '   ' ? textFeildValue + '   ' : textFeildValue;
        } else {
            textObj.value = textFeildValue;
        }
    } else {
        if (textObj.setSelectionRange) {
            var rangeStart = textObj.selectionStart;
            var rangeEnd = textObj.selectionEnd;
            var tempStr1 = textObj.value.substring(0, rangeStart);
            var tempStr2 = textObj.value.substring(rangeEnd);
            textObj.value = tempStr1 + textFeildValue + tempStr2;
        } else {
            alert("This   version   of   Mozilla   based   browser   does   not   support   setSelectionRange");
        }
    }
}
function InsertString(tbid, str){
    var tb = document.getElementById(tbid);
    tb.focus();
    if (document.all){
    	alert('a')
        var r = document.selection.createRange();
        document.selection.empty();
        r.text = str;
        r.collapse();
        r.select();
    }
    else{
        var newstart = tb.selectionStart+str.length;
        tb.value=tb.value.substr(0,tb.selectionStart)+str+tb.value.substring(tb.selectionEnd);
        tb.selectionStart = newstart;
        tb.selectionEnd = newstart;
    }
}
function GetSelection(tbid){


    var sel = '';
    if (document.all){
        var r = document.selection.createRange();
        document.selection.empty();
        sel = r.text;
    }
    else{
    var tb = document.getElementById(tbid);
      // tb.focus();
        var start = tb.selectionStart;
        var end = tb.selectionEnd;
        sel = tb.value.substring(start, end);
    }
    return sel;
}
function ShowSelection(tbid){
var sel = GetSelection(tbid);
    if (sel)
        alert('选中的文本是：'+sel);
    else
        alert('未选择文本！');
}                  