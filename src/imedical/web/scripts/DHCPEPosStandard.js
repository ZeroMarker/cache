/// 名称			DHCPEPosStandard.js
/// 创建时间		2006.11.16
/// 创建人			xuwm
/// 主要功能		导出客户信息到病案管理
/// 对应表		
/// 最后修改时间	
/// 最后修改人	
/// 完成
/// 树型结构操作
var xslTreeFile="../scripts/DHCPETree.xsl";
var xslGroupFile="../scripts/DHCPEPosStandard.GroupList.xsl";
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BQuery");
	if (obj){ obj.onclick=BQuery_click; }
	
	obj=document.getElementById("TName");
	if (obj){
		obj.onclick=TName_click;
		obj.onkeydown = TName_keydown;
	}
	
	obj=document.getElementById("GName");
	if (obj){
		obj.onclick=GName_click;
		obj.onkeydown = GName_keydown;
	}
	
	//日期元素
	SetDate("DateFrom","ldDateFrom");
	SetDate("DateTo","ldDateTo");
	
	iniForm();
}

function iniForm() {
	if (DivTree && xmlTree) {
		CreatePETestListTree(DivTree,xmlTree);
	}
	if (dGroupList && xmlGroupList) {
		CreatePEGroupListTree(dGroupList,xmlGroupList);
	}
}

// 创建项目列表
function CreatePETestListTree(obj, xmlobj) {
	if (""!=xmlobj.innerHTML) {
		// 此函数在DHCPECommon.xml.js
  		load_xmlnFromXMLObject(obj,xmlobj,xslTreeFile); 
  		// 此变量在tree.js
		//var cwin=window.open("","_Black","");
		//cwin.document.write(obj.innerHTML);
		//cwin.document.close();
  		CurExpand=null;
	}	
}

// 创建体检单位列表
function CreatePEGroupListTree(obj, xmlobj) {
	if (""!=xmlobj.innerHTML) {
		// 此函数在DHCPECommon.xml.js
  		load_xmlnFromXMLObject(obj,xmlobj,xslGroupFile); 
  		// 此变量在tree.js
  		CurExpand=null;
	}	
}

// 点击节点自定义函数
function ClickOnCustom(entity) {
	window.event.cancelBubble = true;
}

// 选择节点自定义函数
function checkedOnCustom(entity) {
	window.event.cancelBubble = true;
}

function BQuery_click() {
	var obj;
	

	var TLIst=GetTestList();
	var GList=GetGroupList();
	if ((""==GList)||(""==TLIst)) { return;}
	
	var iDateFrom="";
	var iDateTo="";
	var iAgeFrom="";
	var iAgeTo="";	
	var iSex="";
	obj=document.getElementById("DateFrom");
	if (obj && ""!=obj.value) { iDateFrom = obj.value; }
	obj=document.getElementById("DateTo");
	if (obj && ""!=obj.value) { iDateTo = obj.value; }
	obj=document.getElementById("AgeFrom");
	if (obj && ""!=obj.value) { iAgeFrom = obj.value; }
	obj=document.getElementById("AgeTo");
	if (obj && ""!=obj.value) { iAgeTo = obj.value; }	
	obj=document.getElementById("Sex");
	if (obj && ""!=obj.value) { iSex = obj.value; }

	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPosQuery"
		+"&"+"GList="+GList
		+"&"+"TestList="+TLIst
		+"&"+"DateFrom="+iDateFrom
		+"&"+"DateTo="+iDateTo
		+"&"+"AgeFrom="+iAgeFrom
		+"&"+"AgeTo="+iAgeTo
		+"&"+"Sex="+iSex
		;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';
	//window.open(lnk,"_blank",nwin);
	var df=document.getElementById("dataframe");
	if (df) { df.src=lnk; }
		
}
//获取选择的体检单位
function GetGroupList() {
	var iLLooop=0;
	var obj;
	var GList="";
	do{
		iLLooop=iLLooop+1;
		obj=document.getElementById("GP"+iLLooop);
		if (obj && obj.checked) { GList=GList+obj.value+"^"}
	}while (obj)
	return GList;
}
//获取选择的项目
function GetTestList() {
	var doc=document;
	var Dobj=doc.getElementById("DTree");
	
	if ((Dobj)&& (Dobj.ChildCount>0)) {}
	
	else { return ""; }
	var Cobj;
	var iSLLoop=0; //站点
	var iALLoop=0; //大项
	var iOLLoop=0; //细项
	var strAList="";	//
	var strOList="";	//
	var ret="";
	
	// 站点
	for(iSLLoop=1; iSLLoop<=Dobj.ChildCount; iSLLoop++)
	{
		var Sobj=doc.getElementById("D"+iSLLoop);
		if (Sobj) {
			//alert("站点 iSLLoop:"+iSLLoop+"  Sobj.id:"+Sobj.id+"  Sobj.ChildCount:"+Sobj.ChildCount)
			strAList="";
			// 大项
			for(iALLoop=1; iALLoop<=Sobj.ChildCount; iALLoop++)
			{
				
				var Aobj=doc.getElementById("D"+iSLLoop+iALLoop);
				if (Aobj) 
				{
					//alert("大项子项 iALLoop:"+iALLoop+"  Aobj.id:"+Aobj.id+"  Aobj.ChildCount:"+Aobj.ChildCount);
					strOList="";
					//细项
					for(iOLLoop=1; iOLLoop<=Aobj.ChildCount; iOLLoop++)
					{
						var Oobj=doc.getElementById("D"+iSLLoop+iALLoop+iOLLoop);
						if (Oobj) 
						{					
							Cobj=doc.getElementById("C"+iSLLoop+iALLoop+iOLLoop);
							if (Cobj && Cobj.checked)
							{
								strOList=strOList+Cobj.value+";";
								
							}
						}
					}
					
					//alert("大项选择 iALLoop:"+iALLoop+"  Aobj.id:"+Aobj.id+"  OList"+strOList);
					Cobj=doc.getElementById("C"+iSLLoop+iALLoop);
					if (Cobj && ""!=strOList)
					{
						//alert(strOList);				这个;是为了同一子项地分割格式?以便日益处理 每个子项格式 ";"??子项编码?+";"
						strAList=strAList+Cobj.value+":"+";"+strOList+"^";
					}
					
					
				}//大项
			}//大项循环
			ret=ret+strAList;
		}//站点项
		
	}//站点循环
	return ret;
}

function TName_click() {
	var src=window.event.srcElement;
	if ("请输入项目名称"==src.value) { src.value=""; } 
}

// 不能使用
function TName_keydown(e) {
	return;
	var key=websys_getKey(e);
	if (key==13) {
		
		var SID="";
		var AName="";
		var src=window.event.srcElement;
		var OName=src.value;
		var IsReturn="1";
		
		if (""==OName) { return; }  
		var Ins=document.getElementById('PETestList');
		if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
		var flag=cspRunServerMethod(encmeth,'GetPETestList','',SID,AName,OName,IsReturn);

		if ("1"!=flag) { }
	}
}

function GName_click() {
	var src=window.event.srcElement;
	if ("请输入单位名称"==src.value) { src.value=""; } 
}

function GName_keydown(e) {
	return;
	var src=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		var GName=src.value;
		if (""==GName) { return; }  
		var Ins=document.getElementById('GroupList');
		if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
		var flag=cspRunServerMethod(encmeth,'','','','');

		if (""!=flag) { HISServer=flag; }
	}
}

function QueryGroupList(GName) {
	
		var Ins=document.getElementById('GroupList');
		if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
		var flag=cspRunServerMethod(encmeth,'','');

		if (""!=flag) { HISServer=flag; }
}

document.body.onload = BodyLoadHandler;

// //////////////////////////////////////////////////////////////////////////////
// 以下函数 参考 epr.chartbook.show.csp 
function setDataFrameSize() {
		var obj=document.getElementById("PanelShow");
		resizeframe(obj.style.width,obj.style.height)
}

function resizeframe(remainWdt,remainHgt)
{
	try {
		document.frames["dataframe"].window.resizeTo(remainWdt,remainHgt);
	}
	catch (e) {
		setDataFrameSize();
	}
}
//window.onresize = setDataFrameSize;